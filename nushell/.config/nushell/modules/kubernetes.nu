# This command is used a LOT both below and in daily life
export alias k = kubecolor
export def kgg [] {
  kubecolor api-resources --no-headers | fzf | awk '{print $1}' | xargs kubecolor get
}
export alias kyg = kubectl-get-yaml-fzf
export alias kdg = kubectl-describe-fzf
export alias keg = kubectl-edit-fzf
export alias kex = kubecolor explain
export alias kexp = kubecolor explore

export alias kcx = kubectx
export alias kns = kubens
export alias kbx = kubie ctx
export alias kbs = kubie ns
export alias kt = kubetail
export alias ky = kyverno

# Execute a kubecolor command against all namespaces
# export alias kca='_kca(){ kubecolor "$@" --all-namespaces;  unset -f _kca; }; _kca'

# Generic ones
export alias kd = kubecolor describe
export alias ke = kubecolor edit
export alias kg = kubecolor get
# Apply a YML file
export alias kaf = kubecolor apply -f

# Drop into an interactive terminal on a container
export alias keti = kubecolor exec -t -i

# Manage configuration quickly to switch contexts between local, dev ad staging.
export alias kcuc = kubecolor config use-context
export alias kcsc = kubecolor config set-context
export alias kcdc = kubecolor config delete-context
export alias kccc = kubecolor config current-context
export alias kcgc = kubecolor config get-contexts

# General export aliases
export alias kdel = kubecolor delete
export alias kdelf = kubecolor delete -f

# Pod management.
export alias kgp = kubecolor get pods
export alias kgpa = kubecolor get pods --all-namespaces
export alias kgpw = kgp --watch
export alias kgpwide = kgp -o wide
export alias kep = kubecolor edit pods
export alias kdp = kubecolor describe pods
export alias kdpp = kubecolor get pods --no-headers | fzf | awk \''{print $1}'\'' | xargs kubecolor describe pods'
export alias kdelp = kubecolor delete pods
export alias kgpall = kubecolor get pods --all-namespaces -o wide
# get pod by label: kgpl "app=myapp" -n myns
export alias kgpl = kgp -l
# get pod by namespace: kgpn kube-system"
export alias kgpn = kgp -n

# Service management.
export alias kgs = kubecolor get svc
export alias kgsa = kubecolor get svc --all-namespaces
export alias kgsw = kgs --watch
export alias kgswide = kgs -o wide
export alias kes = kubecolor edit svc
export alias kds = kubecolor describe svc
export alias kdels = kubecolor delete svc

# Endpoint management.
export alias kge = kubecolor get endpoints
export alias kgea = kubecolor get endpoints --all-namespaces
export alias kgew = kge --watch
export alias kgewide = kge -o wide
export alias kee = kubecolor edit endpoints
export alias kde = kubecolor describe endpoints
export alias kdele = kubecolor delete endpoints

# Ingress management
export alias kgi = kubecolor get ingress
export alias kgia = kubecolor get ingress --all-namespaces
export alias kei = kubecolor edit ingress
export alias kdi = kubecolor describe ingress
export alias kdeli = kubecolor delete ingress

# Namespace management
export alias kgns = kubecolor get namespaces
export alias kens = kubecolor edit namespace
export alias kdns = kubecolor describe namespace
export alias kdelns = kubecolor delete namespace
export alias kcn = kubecolor config set-context --current --namespace

# ConfigMap management
export alias kgcm = kubecolor get configmaps
export alias kgcma = kubecolor get configmaps --all-namespaces
export alias kecm = kubecolor edit configmap
export alias kdcm = kubecolor describe configmap
export alias kdelcm = kubecolor delete configmap

# Secret management
export alias kgsec = kubecolor get secret
export alias kgseca = kubecolor get secret --all-namespaces
export alias kesec = kubecolor edit secret
export alias kdsec = kubecolor describe secret
export alias kdelsec = kubecolor delete secret

# External secrets
export alias kges = kubecolor get es
export alias kgesa = kubecolor get es --all-namespaces
export alias kees = kubecolor describe es
export alias kdes = kubecolor describe es
export alias kdeles = kubecolor delete es

# Deployment management.
export alias kgd = kubecolor get deployment
export alias kgda = kubecolor get deployment --all-namespaces
export alias kgdw = kgd --watch
export alias kgdwide = kgd -o wide
export alias ked = kubecolor edit deployment
export alias kdd = kubecolor describe deployment
export alias kdeld = kubecolor delete deployment
export alias ksd = kubecolor scale deployment
export alias krsd = kubecolor rollout status deployment

# Run temporary debug pod
export alias krd = kubecolor run -it --restart=Never --image=markeijsermans/debug --rm=true
export alias krt = kubecolor run -it --restart=Never --rm=true

# Rollout management.
export alias kgrs = kubecolor get replicaset
export alias kdrs = kubecolor describe replicaset
export alias kers = kubecolor edit replicaset
export alias krh = kubecolor rollout history
export alias kru = kubecolor rollout undo

# Statefulset management.
export alias kgss = kubecolor get statefulset
export alias kgssa = kubecolor get statefulset --all-namespaces
export alias kgssw = kgss --watch
export alias kgsswide = kgss -o wide
export alias kess = kubecolor edit statefulset
export alias kdss = kubecolor describe statefulset
export alias kdelss = kubecolor delete statefulset
export alias ksss = kubecolor scale statefulset
export alias krsss = kubecolor rollout status statefulset

# Port forwarding
export alias kpf = kubecolor port-forward

# Tools for accessing all information
export alias kga = kubecolor get all
export alias kall = kubectl-get-all # get everything in all namespaces including crds
export alias kgaa = kubecolor get all --all-namespaces

# Logs
export alias kl = kubecolor logs
export alias klg = kubecolor get pods --no-headers | fzf | awk \''{print $1}'\'' | xargs kubecolor logs'
export alias klgp = kubecolor get pods --no-headers | fzf | awk \''{print $1}'\'' | xargs kubecolor logs -p'
export alias kl1h = kubecolor logs --since 1h
export alias kl1m = kubecolor logs --since 1m
export alias kl1s = kubecolor logs --since 1s
export alias klf = kubecolor logs -f
export alias klf1h = kubecolor logs --since 1h -f
export alias klf1m = kubecolor logs --since 1m -f
export alias klf1s = kubecolor logs --since 1s -f

# File copy
export alias kcp = kubecolor cp

# Node Management
export alias kgno = kubecolor get nodes
export alias keno = kubecolor edit node
export alias kdno = kubecolor describe node
export alias kdelno = kubecolor delete node

# PVC management.
export alias kgpvc = kubecolor get pvc
export alias kgpvca = kubecolor get pvc --all-namespaces
export alias kgpvcw = kgpvc --watch
export alias kepvc = kubecolor edit pvc
export alias kdpvc = kubecolor describe pvc
export alias kdelpvc = kubecolor delete pvc

# Service account management.
export alias kdsa = kubecolor describe sa
export alias kdelsa = kubecolor delete sa

# DaemonSet management.
export alias kgds = kubecolor get daemonset
export alias kgdsw = kgds --watch
export alias keds = kubecolor edit daemonset
export alias kdds = kubecolor describe daemonset
export alias kdelds = kubecolor delete daemonset

# Network policy management.
export alias kgnp = kubecolor get netpol
export alias kgnpw = kgnp --watch
export alias kenp = kubecolor edit netpol
export alias kdnp = kubecolor describe netpol
export alias kdelnp = kubecolor delete netpol

# CronJob management.
export alias kgcj = kubecolor get cronjob
export alias kecj = kubecolor edit cronjob
export alias kdcj = kubecolor describe cronjob
export alias kdelcj = kubecolor delete cronjob

# Job management.
export alias kgj = kubecolor get job
export alias kej = kubecolor edit job
export alias kdj = kubecolor describe job
export alias kdelj = kubecolor delete job

# calico network policies
export alias kgnc = kubecolor get networkpolicies.crd.projectcalico.org
export alias kdnc = kubecolor describe networkpolicies.crd.projectcalico.org
export alias kenc = kubecolor edit networkpolicies.crd.projectcalico.org
export alias kdelnc = kubecolor delete networkpolicies.crd.projectcalico.org
export alias kgng = kubecolor get globalnetworkpolicies.crd.projectcalico.org
export alias kdng = kubecolor describe globalnetworkpolicies.crd.projectcalico.org
export alias keng = kubecolor edit globalnetworkpolicies.crd.projectcalico.org
export alias kdelng = kubecolor delete globalnetworkpolicies.crd.projectcalico.org

# persistent volumes
export alias kgpv = kubecolor get persistentvolume
export alias kepv = kubecolor edit persistentvolume
export alias kdpv = kubecolor describe persistentvolume
export alias kdelpv = kubecolor delete persistentvolume

# storage classes
export alias kgsc = kubecolor get storageclass
export alias kesc = kubecolor edit storageclass
export alias kdsc = kubecolor describe storageclass
export alias kdelsc = kubecolor delete storageclass
