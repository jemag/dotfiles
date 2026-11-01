# Run our own CVE data mirror instead of the upstream all-in-one image

## Context

`tanka/lib/dependency-track/resources/cve-data-mirror/cve-data-mirror.libsonnet` (kubernetes-platform) runs
the upstream `jeremylong/open-vulnerability-data-mirror` image. Only sandbox wires it in, through
`environments/dependency-track/sandbox/main.jsonnet` and `environments/network-policies/sandbox/main.jsonnet`.

That image runs supervisord, httpd and crond as root, needs four added capabilities, writes to its root
filesystem, and reports a failed sync as success (`mirror.sh` exits 0 after a failed vulnz run). It would
not pass Kyverno in test and prod, where `environments/kyverno-policies/{test,prod}` set
`validationActions: ['Deny']` for `require-run-as-non-root`, `require-ro-rootfs` and `disallow-capabilities`.

Plan: split the mirror into two workloads that each do one thing, both on Chainguard images built in the
Images repo.

| Workload | Role | Image | Runs as | Root filesystem | Capabilities | Network |
|---|---|---|---|---|---|---|
| `cve-data-mirror-sync` (CronJob) | Runs the vulnz JAR into the PVC | `vulnz` on `cgr.dev/chainguard/jre`, JAR signature-verified at build time | uid 65532 | read-only | none | egress 443 only |
| `cve-data-mirror` (Deployment) | Serves only the files Dependency-Track fetches | `cve-data-mirror-nginx` on `cgr.dev/chainguard/nginx`, config baked in | uid 65532 | read-only | none | ingress from the api-server only, no egress |

Storage moves from the proof of concept's Azure Disk (`nvd-cache-pvc`, ReadWriteOnce) to a ReadWriteMany
Azure Files (SMB) share. That lets the sync Job and the nginx replicas mount the cache from any node. The new
share starts empty, so the first sync downloads the full NVD history.

What stays the same:
- **Service name:** `cve-data-mirror-service`, so the "CVE Feeds URL" setting in Dependency-Track keeps
  working.
- **Library signature:** `new(...)` gains one `environment` parameter to build the storage account name;
  that is the only change.

**Prerequisite outside this repo:** create a `nvd-mirror-share` file share (10 GiB quota) in each
`aks<env>dtrack` storage account, wherever `dtrack-share` is managed.

## Part A: Images repo (`~/Projects/Images`)

Both images follow `images/nushell-delete-old-velero-snapshots/Dockerfile`:
- `cgr.dev` base pinned by digest
- the `org.opencontainers.image.*` and maintainer labels
- `USER 65532` and `HEALTHCHECK NONE`

The shared pipelines pick them up with no pipeline changes and push them as
`coastcommonacr.azurecr.io/aks/<dir>:<yyyyMMdd.r>`. Renovate then keeps the base digests current.

### A1. `images/vulnz/Dockerfile` (new)

```dockerfile
# Fetch and verify the vulnz release jar; nothing from this stage but the jar ships.
FROM cgr.dev/chainguard/wolfi-base@sha256:<digest> AS fetch

# Install vulnz (pinned to v9.0.6)
# NOTE: VULNZ_SHA256 must be updated together with VULNZ_VERSION, after the gpg
# check below has passed for the new release.
ARG VULNZ_VERSION=9.0.6
ARG VULNZ_SHA256=<sha256 of vulnz-9.0.6.jar>
COPY vulnz-release-key.asc /tmp/vulnz-release-key.asc
RUN apk add --no-cache curl gnupg \
  && base="https://github.com/jeremylong/open-vulnerability-cli/releases/download/v${VULNZ_VERSION}" \
  && curl -fsSL -o /tmp/vulnz.jar "${base}/vulnz-${VULNZ_VERSION}.jar" \
  && curl -fsSL -o /tmp/vulnz.jar.asc "${base}/vulnz-${VULNZ_VERSION}.jar.asc" \
  && echo "${VULNZ_SHA256}  /tmp/vulnz.jar" | sha256sum -c - \
  && gpg --batch --import /tmp/vulnz-release-key.asc \
  && gpg --batch --verify /tmp/vulnz.jar.asc /tmp/vulnz.jar \
  && rm -rf /tmp/vulnz.jar.asc /tmp/vulnz-release-key.asc /root/.gnupg

FROM cgr.dev/chainguard/jre@sha256:<digest>
LABEL org.opencontainers.image.source="https://dev.azure.com/foc-poc/AKS/_git/Images"
LABEL org.opencontainers.image.description="vulnz (open-vulnerability-cli) NVD mirror job"
LABEL maintainer="alexandre.brassard-desjardins@dfo-mpo.gc.ca"

COPY --from=fetch --chown=65532:65532 /tmp/vulnz.jar /app/vulnz.jar

USER 65532

HEALTHCHECK NONE
ENTRYPOINT ["java", "-jar", "/app/vulnz.jar"]
```

`images/vulnz/vulnz-release-key.asc` (new) is Jeremy Long's public key, exported once
(`gpg --recv-keys … && gpg --armor --export …`). The release page shows `FFDE55BE73A2D1ED` as his
commit-signing key. **Assumes the `.jar.asc` release files are signed with that same key.** Confirm with one
manual `gpg --verify` before committing the key and the sha256.

**Java version:** **Assumes vulnz 9.0.6 runs on whatever OpenJDK `cgr.dev/chainguard/jre` currently ships.**
The free Chainguard tier only publishes `latest`, which follows the newest JDK, while upstream ships
OpenJDK 17. The first sandbox run settles this. If it fails, we either use a versioned Chainguard tag (needs
a subscription) or install a pinned `openjdk-17-jre` from Wolfi on `wolfi-base`.

### A2. `images/cve-data-mirror-nginx/Dockerfile` (new)

```dockerfile
FROM cgr.dev/chainguard/nginx@sha256:<digest>
LABEL org.opencontainers.image.source="https://dev.azure.com/foc-poc/AKS/_git/Images"
LABEL org.opencontainers.image.description="Static server for the Dependency-Track NVD feed mirror"
LABEL maintainer="alexandre.brassard-desjardins@dfo-mpo.gc.ca"

COPY nginx.conf /etc/nginx/nginx.conf

USER 65532

HEALTHCHECK NONE
```

### A3. `images/cve-data-mirror-nginx/nginx.conf` (new)

This replaces `mirror.conf` in kubernetes-platform.
- **Writable paths:** the main config is replaced entirely, so every writable path points at `/tmp` (an
  emptyDir) and the root filesystem can stay read-only.
- **No `daemon` directive:** the Chainguard entrypoint already passes `-g "daemon off;"`, and setting it here
  too would make nginx fail on a duplicate directive.

```nginx
worker_processes 1;
pid /tmp/nginx.pid;
error_log /dev/stderr warn;

events {
    worker_connections 256;
}

http {
    access_log /dev/stdout;
    server_tokens off;
    # The feeds live on an Azure Files (SMB) share; sendfile on network
    # filesystems can serve stale or truncated data.
    sendfile off;
    default_type application/octet-stream;

    client_body_temp_path /tmp/client_body;
    proxy_temp_path /tmp/proxy;
    fastcgi_temp_path /tmp/fastcgi;
    uwsgi_temp_path /tmp/uwsgi;
    scgi_temp_path /tmp/scgi;

    # Serves only the NVD feed files Dependency-Track requests. It requests
    # {cveFeedsUrl}/json/cve/2.0/nvdcve-2.0-<feed>.<ext>, while vulnz writes
    # <cache>/nvdcve-<feed>.<ext>.
    server {
        listen 8080;
        autoindex off;

        location ~ "^/json/cve/2\.0/nvdcve-2\.0-([a-z0-9]+)\.(meta|json\.gz)$" {
            limit_except GET { deny all; }
            types { text/plain meta; application/gzip gz; }
            alias /srv/mirror/nvdcve-$1.$2;
        }

        location / {
            return 404;
        }
    }
}
```

This allow-list replaces the old deny-list (`.nvd_requests`, plus `.vulnz-staging` and the lock file
upstream). It also drops server-side includes.

**Startup warning:** nginx may log one `[alert] could not open error log file` while it starts, because it
tries the compiled-in log path before reading this config. That alert is harmless.

**Validation:** open an Images PR. `images-pr.yml` lints, builds and scans both images. Review the trivy and
dockle output in the logs, because scans don't fail the build.

## Part B: kubernetes-platform

### B1. `tanka/lib/dependency-track/resources/cve-data-mirror/cve-data-mirror.libsonnet` (full replacement)

`git rm tanka/lib/dependency-track/resources/cve-data-mirror/mirror.conf`. The config now ships in the image,
so the ConfigMap goes away too.

```jsonnet
// Local NVD feed mirror. A CronJob runs vulnz (open-vulnerability-cli) to pull
// CVEs from the NVD REST API into yearly feed files on a PVC, and nginx serves
// them in the layout Dependency-Track expects, so its "CVE Feeds URL" can point
// here instead of nvd.nist.gov. Both images are built in the Images repo.
local name = 'cve-data-mirror';
local syncImage = 'coastcommonacr.azurecr.io/aks/vulnz:<yyyyMMdd.r>@sha256:<digest>';
local serverImage = 'coastcommonacr.azurecr.io/aks/cve-data-mirror-nginx:<yyyyMMdd.r>@sha256:<digest>';
local serverLabels = { 'app.kubernetes.io/name': name, 'app.kubernetes.io/component': 'server' };
local syncLabels = { 'app.kubernetes.io/name': name, 'app.kubernetes.io/component': 'sync' };
// Chainguard images run as nonroot (65532). The Azure Files share is mounted
// with the same uid/gid, since the azurefile CSI driver ignores fsGroup for
// ReadWriteMany volumes.
local uid = 65532;

local podSecurityContext = {
  runAsNonRoot: true,
  runAsUser: uid,
  runAsGroup: uid,
  seccompProfile: { type: 'RuntimeDefault' },
};
local containerSecurityContext = {
  allowPrivilegeEscalation: false,
  readOnlyRootFilesystem: true,
  capabilities: { drop: ['ALL'] },
};
local tmpVolume = { name: 'tmp', emptyDir: { sizeLimit: '256Mi' } };
local tmpMount = { name: 'tmp', mountPath: '/tmp' };

{
  new(namespace, apiKeySecretName, environment):: {
    // The Service name matches the manually applied proof of value, so the CVE
    // Feeds URL already set in Dependency-Track keeps working.
    local serviceName = '%s-service' % name,
    local cronJobName = '%s-sync' % name,
    local claimName = '%s-cache' % name,
    local volumeName = '%s-cache-pv-%s' % [name, environment],

    deployment: {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      metadata: { name: name, namespace: namespace, labels: serverLabels },
      spec: {
        replicas: 2,
        selector: { matchLabels: serverLabels },
        template: {
          metadata: { labels: serverLabels },
          spec: {
            automountServiceAccountToken: false,
            securityContext: podSecurityContext,
            containers: [
              {
                name: 'nginx',
                image: serverImage,
                ports: [{ name: 'http', containerPort: 8080 }],
                securityContext: containerSecurityContext,
                resources: {
                  requests: { cpu: '10m', memory: '32Mi' },
                  limits: { memory: '128Mi' },
                },
                // vulnz writes the modified feed last, so the pod only receives
                // traffic once a complete mirror exists.
                readinessProbe: {
                  httpGet: { path: '/json/cve/2.0/nvdcve-2.0-modified.meta', port: 'http' },
                  periodSeconds: 30,
                  failureThreshold: 3,
                },
                volumeMounts: [
                  { name: 'cache', mountPath: '/srv/mirror', readOnly: true },
                  tmpMount,
                ],
              },
            ],
            volumes: [
              { name: 'cache', persistentVolumeClaim: { claimName: claimName, readOnly: true } },
              tmpVolume,
            ],
          },
        },
      },
    },

    cronJob: {
      apiVersion: 'batch/v1',
      kind: 'CronJob',
      metadata: { name: cronJobName, namespace: namespace, labels: syncLabels },
      spec: {
        schedule: '17 */6 * * *',
        concurrencyPolicy: 'Forbid',
        startingDeadlineSeconds: 3600,
        successfulJobsHistoryLimit: 1,
        failedJobsHistoryLimit: 3,
        jobTemplate: {
          metadata: { labels: syncLabels },
          spec: {
            backoffLimit: 4,
            activeDeadlineSeconds: 4 * 3600,
            // vulnz exits 100 when NVD downloads fail; only that is worth a retry.
            podFailurePolicy: {
              rules: [
                { action: 'FailJob', onExitCodes: { operator: 'NotIn', values: [100] } },
              ],
            },
            template: {
              metadata: { labels: syncLabels },
              spec: {
                restartPolicy: 'Never',
                automountServiceAccountToken: false,
                securityContext: podSecurityContext,
                containers: [
                  {
                    name: 'vulnz',
                    image: syncImage,
                    args: [
                      'cve',
                      '--cache',
                      '--directory=/cache',
                      // Without a delay the API key causes vulnz to hit NVD's rate
                      // limit, which it reports as "Invalid API Key".
                      '--delay=6000',
                      '--maxRetry=10',
                      // 2000-record pages regularly time out at NVD's CDN (HTTP 524).
                      '--recordsPerPage=500',
                    ],
                    env: [
                      {
                        name: 'NVD_API_KEY',
                        valueFrom: { secretKeyRef: { name: apiKeySecretName, key: 'NVD_API_KEY' } },
                      },
                      { name: 'HOME', value: '/tmp' },
                      { name: 'JAVA_TOOL_OPTIONS', value: '-Xmx4g -XX:+UseStringDeduplication -Djava.io.tmpdir=/tmp' },
                    ],
                    securityContext: containerSecurityContext,
                    resources: {
                      requests: { cpu: '100m', memory: '1Gi' },
                      limits: { memory: '5Gi' },
                    },
                    volumeMounts: [
                      { name: 'cache', mountPath: '/cache' },
                      tmpMount,
                    ],
                  },
                ],
                volumes: [
                  { name: 'cache', persistentVolumeClaim: { claimName: claimName } },
                  tmpVolume,
                ],
              },
            },
          },
        },
      },
    },

    service: {
      apiVersion: 'v1',
      kind: 'Service',
      metadata: { name: serviceName, namespace: namespace, labels: serverLabels },
      spec: {
        selector: serverLabels,
        ports: [{ name: 'http', protocol: 'TCP', port: 80, targetPort: 'http' }],
      },
    },

    podDisruptionBudget: {
      apiVersion: 'policy/v1',
      kind: 'PodDisruptionBudget',
      metadata: { name: name, namespace: namespace, labels: serverLabels },
      spec: {
        minAvailable: 1,
        selector: { matchLabels: serverLabels },
      },
    },

    // Static PV on a dedicated share in the Dependency-Track storage account,
    // reached over its private endpoint like dependency-track-v5-storage.
    persistentVolume: {
      apiVersion: 'v1',
      kind: 'PersistentVolume',
      metadata: { name: volumeName, labels: { 'app.kubernetes.io/name': name } },
      spec: {
        capacity: { storage: '10Gi' },
        accessModes: ['ReadWriteMany'],
        persistentVolumeReclaimPolicy: 'Retain',
        mountOptions: [
          'uid=%d' % uid,
          'gid=%d' % uid,
          'dir_mode=0755',
          'file_mode=0644',
          'mfsymlinks',
          'cache=strict',
          'nosharesock',
          'actimeo=30',
          'nobrl',
        ],
        csi: {
          driver: 'file.csi.azure.com',
          volumeHandle: volumeName,
          volumeAttributes: {
            storageAccount: 'aks%sdtrack' % environment,
            shareName: 'nvd-mirror-share',
            server: 'aks%sdtrack.privatelink.file.core.windows.net' % environment,
          },
          nodeStageSecretRef: { name: 'dtrack-azurefile-secret', namespace: namespace },
        },
      },
    },

    persistentVolumeClaim: {
      apiVersion: 'v1',
      kind: 'PersistentVolumeClaim',
      metadata: { name: claimName, namespace: namespace, labels: { 'app.kubernetes.io/name': name } },
      spec: {
        accessModes: ['ReadWriteMany'],
        storageClassName: '',
        volumeName: volumeName,
        resources: { requests: { storage: '10Gi' } },
      },
    },

    prometheusRule: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'PrometheusRule',
      metadata: {
        name: name,
        namespace: namespace,
        labels: { release: 'kube-prometheus-stack' },
      },
      spec: {
        groups: [
          {
            name: name,
            rules: [
              {
                alert: 'CveDataMirrorStale',
                expr: 'time() - kube_cronjob_status_last_successful_time{namespace="%s", cronjob="%s"} > 86400' % [namespace, cronJobName],
                'for': '30m',
                labels: { severity: 'warning' },
                annotations: {
                  summary: 'The NVD mirror has not synced successfully in over 24h.',
                  description: 'Dependency-Track keeps serving the last good feed, so new CVEs are being missed. Check the %s jobs in %s.' % [cronJobName, namespace],
                },
              },
            ],
          },
        ],
      },
    },
  },
}
```

Notes on this file:
- **Ownership and permissions:** `file.csi.azure.com` uses `fsGroupPolicy: ReadWriteOnceWithFSType`, so the
  kubelet ignores `fsGroup` on this ReadWriteMany volume. The `uid`/`gid`/`*_mode` mount options make
  everything owned by 65532, which both containers run as.
  - Only the sync container mounts the share read-write. nginx mounts it `readOnly`.
  - This is tighter than the `0777` used on `dependency-track-v5-storage`.
- **Scheduling and availability:** no `podAffinity`. The Job runs on any node, and nginx runs 2 replicas with
  the default `RollingUpdate` and a PDB, so rollouts and node drains don't cause an outage.
- **Main risk:** vulnz replaces feed files by renaming over them, which can fail on SMB while nginx has a
  file open. The Linux CIFS client opens files with share-delete, so this should work, but it's unverified
  on Azure Files. Verification step 5 tests it directly. If it fails, the fallback is an NFS share on a
  Premium FileStorage account; only the PV's `csi` block and mount options change.
- **Locking:** `nobrl` makes byte-range locks local only. That's safe because `concurrencyPolicy: Forbid`
  ensures only one writer at a time.
- **Schedule:** the sync runs every 6 hours (the old crontab ran daily). Each run only pulls changes since the
  last one, so the extra NVD traffic is small.
- **Writable paths:** `HOME=/tmp` and `java.io.tmpdir=/tmp` cover what vulnz needs besides `--directory`
  while the root filesystem stays read-only.
- **Dropped:** EPSS and KEV mirroring (`epss.sh`, `kev.sh`) are left out on purpose. Dependency-Track only
  points its CVE Feeds URL here. **Assumes Dependency-Track fetches EPSS and KEV itself.**

### B2. Network policies

**`tanka/lib/network-policies/resources/dependency-track/dependency-track-cve-data-mirror.json`** becomes two
policies, one per component:

```json
{
  "dependencyTrackCveDataMirrorServer": {
    "apiVersion": "projectcalico.org/v3",
    "kind": "NetworkPolicy",
    "metadata": {
      "name": "dependency-track-cve-data-mirror-server-network",
      "namespace": "dependency-track"
    },
    "spec": {
      "ingress": [
        {
          "action": "Allow",
          "destination": {
            "ports": [8080]
          },
          "protocol": "TCP",
          "source": {
            "selector": "projectcalico.org/orchestrator == 'k8s' && app.kubernetes.io/instance == 'dependency-track' && app.kubernetes.io/name == 'dependency-track-api-server'"
          }
        }
      ],
      "order": 5000,
      "selector": "projectcalico.org/orchestrator == 'k8s' && app.kubernetes.io/name == 'cve-data-mirror' && app.kubernetes.io/component == 'server'",
      "tier": "default",
      "types": ["Ingress", "Egress"]
    }
  },
  "dependencyTrackCveDataMirrorSync": {
    "apiVersion": "projectcalico.org/v3",
    "kind": "NetworkPolicy",
    "metadata": {
      "name": "dependency-track-cve-data-mirror-sync-network",
      "namespace": "dependency-track"
    },
    "spec": {
      "egress": [
        {
          "action": "Allow",
          "destination": {
            "ports": [443]
          },
          "protocol": "TCP",
          "source": {}
        }
      ],
      "order": 5000,
      "selector": "projectcalico.org/orchestrator == 'k8s' && app.kubernetes.io/name == 'cve-data-mirror' && app.kubernetes.io/component == 'sync'",
      "tier": "default",
      "types": ["Ingress", "Egress"]
    }
  }
}
```

- **Server:** has no egress rules, so it can only reach DNS (allowed by the namespace-wide policy).
- **Sync:** accepts no ingress at all.
- **Limit:** open-source Calico can't restrict egress by domain, so the sync pod can still reach any host on
  443, as it can today.

**`tanka/lib/network-policies/resources/dependency-track/dependency-track-api-server.json`** gets one more
egress rule, appended after the trivy-server rule at line 39. Today the api-server only has egress to 443,
the database and Trivy. The namespace's `denyAll` would then drop api-server → mirror traffic. **If the
sandbox proof of concept worked without this rule, something else allows it; check the
`zzz-dependency-track-ns-log-blocked-traffic` logs before adding it.**

```json
        {
          "action": "Allow",
          "destination": {
            "selector": "projectcalico.org/orchestrator == 'k8s' && app.kubernetes.io/name == 'cve-data-mirror' && app.kubernetes.io/component == 'server'",
            "ports": [8080]
          },
          "protocol": "TCP",
          "source": {}
        }
```

`environments/network-policies/sandbox/main.jsonnet:10,142` keeps importing the JSON file unchanged; the file
now contributes two policies.

### B3. Environments

- **Sandbox:** in `environments/dependency-track/sandbox/main.jsonnet`, pass the environment to the existing
  call (around line 76):

  ```diff
   local cveDataMirror = cveDataMirrorLib.new(
     namespace=namespace,
     apiKeySecretName='nvd-api-key-secret',
  +  environment=env,
   );
  ```
- **Dev, test and prod:** copy sandbox's three additions (the `cveDataMirrorLib` import, the `nvdApiKeyEs`
  ExternalSecret and `cveDataMirror: cveDataMirror`), plus the network-policy import, once sandbox has run
  cleanly through a few sync cycles. Each environment's key vault needs an `nvd-api-key-secret` entry, and
  each Dependency-Track instance needs its CVE Feeds URL set to
  `http://cve-data-mirror-service.dependency-track.svc.cluster.local`.

**Cutover in sandbox:**
1. **Deployment:** its selector gains a `component` label, and selectors can't be changed in place. Either
   delete the old `cve-data-mirror` Deployment once, or let ArgoCD replace it with `Replace=true`.
2. **Old resources:** ArgoCD prunes the `mirror-config` ConfigMap and the `nvd-cache-pvc` PVC, or you
   delete them by hand. Before deleting the old Azure Disk, check whether its PV's reclaim policy is
   `Delete`.
3. **Initial sync:** the new share starts empty, so nginx stays NotReady until the first sync finishes.
   Trigger it straight away with
   `kubectl -n dependency-track create job --from=cronjob/cve-data-mirror-sync sync-initial`. A full
   download takes a few hours at `--delay=6000`.
4. **During that window:** Dependency-Track's NVD task fails against the mirror until nginx is Ready. That
   only delays CVE updates; it doesn't affect the data Dependency-Track already has.

## Order of work

1. Images PR with `images/vulnz` and `images/cve-data-mirror-nginx`. Merge it, then note the two pushed
   tags and digests.
2. Create `nvd-mirror-share` in `akssandboxdtrack`, wherever that storage account is managed.
3. kubernetes-platform change with those tags and digests filled into `syncImage` and `serverImage`.

## Verification

1. **Images:** check the PR validation logs for a successful build, then review the trivy and dockle findings.
   The `gpg --verify` and `sha256sum -c` steps fail the build if the JAR doesn't match.
2. **Render:** `tk eval tanka/environments/dependency-track/sandbox` and
   `tk eval tanka/environments/network-policies/sandbox` should produce valid output with:
   - a `CronJob` and a `PrometheusRule`
   - the `PersistentVolume`, `PersistentVolumeClaim` (ReadWriteMany) and `PodDisruptionBudget`
   - the two mirror NetworkPolicies
   - no `ConfigMap` for the mirror
3. **Kyverno:** check the output against the rules. Every container should have `runAsNonRoot`,
   `readOnlyRootFilesystem`, no `capabilities.add`, and requests and limits.
4. **Generated manifests:** regenerate `k8s/` with the repo's usual script (`automation/update-k8s-*.sh`) and
   review the diff under `k8s/dependency-track/sandbox` and `k8s/network-policies/sandbox`.
5. **After you sync sandbox:**
   - Run `kubectl -n dependency-track create job --from=cronjob/cve-data-mirror-sync sync-manual` and confirm
     it completes. That also confirms the Chainguard JRE version works. Re-run with a bad key to confirm the
     Job goes Failed rather than Succeeded.
   - From the api-server pod, `curl -sI http://cve-data-mirror-service/json/cve/2.0/nvdcve-2.0-modified.meta`
     should return 200, and `curl -sI .../cache.properties` should return 404.
   - **SMB replace test:** run a `--forceUpdate` sync Job (or wait for one that rewrites yearly feeds). While
     it runs, loop full downloads of a large feed from the api-server pod
     (`while true; do curl -s -o /dev/null -w '%{http_code} %{size_download}\n' …/nvdcve-2.0-2024.json.gz; done`).
     The Job must complete with no rename or permission errors, and the downloads must stay 200 with
     consistent sizes.
   - In Dependency-Track, trigger the NVD mirror task and confirm its logs fetch from the internal URL.
   - Check Policy Reporter for zero Kyverno violations on the `cve-data-mirror` workloads.
