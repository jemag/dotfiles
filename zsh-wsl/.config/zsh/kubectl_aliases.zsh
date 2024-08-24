# This command is used a LOT both below and in daily life
alias k=kubectl
alias kgg='kubectl api-resources --no-headers | fzf | awk '\''{print $1}'\'' | xargs kubectl get'
alias kyg=kubectl-get-yaml-fzf
alias kdg=kubectl-describe-fzf
alias keg=kubectl-edit-fzf

alias kcx="kubectx"
alias kns="kubens"
alias kbx="kubie ctx"
alias kbs="kubie ns"
alias kt="kubetail"
alias ky="kyverno"
# Execute a kubectl command against all namespaces
alias kca='_kca(){ kubectl "$@" --all-namespaces;  unset -f _kca; }; _kca'

# Generic ones
alias kd="kubectl describe"
alias ke="kubectl edit"
alias kg="kubectl get"
# Apply a YML file
alias kaf='kubectl apply -f'

# Drop into an interactive terminal on a container
alias keti='kubectl exec -t -i'

# Manage configuration quickly to switch contexts between local, dev ad staging.
alias kcuc='kubectl config use-context'
alias kcsc='kubectl config set-context'
alias kcdc='kubectl config delete-context'
alias kccc='kubectl config current-context'
alias kcgc='kubectl config get-contexts'

# General aliases
alias kdel='kubectl delete'
alias kdelf='kubectl delete -f'

# Pod management.
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='kubectl edit pods'
alias kdp='kubectl describe pods'
alias kdpp='kubectl get pods --no-headers | fzf | awk '\''{print $1}'\'' | xargs kubectl describe pods'
alias kdelp='kubectl delete pods'
alias kgpall='kubectl get pods --all-namespaces -o wide'
# get pod by label: kgpl "app=myapp" -n myns
alias kgpl='kgp -l'
# get pod by namespace: kgpn kube-system"
alias kgpn='kgp -n'

# Service management.
alias kgs='kubectl get svc'
alias kgsa='kubectl get svc --all-namespaces'
alias kgsw='kgs --watch'
alias kgswide='kgs -o wide'
alias kes='kubectl edit svc'
alias kds='kubectl describe svc'
alias kdels='kubectl delete svc'

# Endpoint management.
alias kge='kubectl get endpoints'
alias kgea='kubectl get endpoints --all-namespaces'
alias kgew='kge --watch'
alias kgewide='kge -o wide'
alias kee='kubectl edit endpoints'
alias kde='kubectl describe endpoints'
alias kdele='kubectl delete endpoints'

# Ingress management
alias kgi='kubectl get ingress'
alias kgia='kubectl get ingress --all-namespaces'
alias kei='kubectl edit ingress'
alias kdi='kubectl describe ingress'
alias kdeli='kubectl delete ingress'

# Namespace management
alias kgns='kubectl get namespaces'
alias kens='kubectl edit namespace'
alias kdns='kubectl describe namespace'
alias kdelns='kubectl delete namespace'
alias kcn='kubectl config set-context --current --namespace'

# ConfigMap management
alias kgcm='kubectl get configmaps'
alias kgcma='kubectl get configmaps --all-namespaces'
alias kecm='kubectl edit configmap'
alias kdcm='kubectl describe configmap'
alias kdelcm='kubectl delete configmap'

# Secret management
alias kgsec='kubectl get secret'
alias kgseca='kubectl get secret --all-namespaces'
alias kdsec='kubectl describe secret'
alias kdelsec='kubectl delete secret'

# Deployment management.
alias kgd='kubectl get deployment'
alias kgda='kubectl get deployment --all-namespaces'
alias kgdw='kgd --watch'
alias kgdwide='kgd -o wide'
alias ked='kubectl edit deployment'
alias kdd='kubectl describe deployment'
alias kdeld='kubectl delete deployment'
alias ksd='kubectl scale deployment'
alias krsd='kubectl rollout status deployment'

# Rollout management.
alias kgrs='kubectl get replicaset'
alias kdrs='kubectl describe replicaset'
alias kers='kubectl edit replicaset'
alias krh='kubectl rollout history'
alias kru='kubectl rollout undo'

# Statefulset management.
alias kgss='kubectl get statefulset'
alias kgssa='kubectl get statefulset --all-namespaces'
alias kgssw='kgss --watch'
alias kgsswide='kgss -o wide'
alias kess='kubectl edit statefulset'
alias kdss='kubectl describe statefulset'
alias kdelss='kubectl delete statefulset'
alias ksss='kubectl scale statefulset'
alias krsss='kubectl rollout status statefulset'

# Port forwarding
alias kpf="kubectl port-forward"

# Tools for accessing all information
alias kga='kubectl get all'
alias kac=kubectl-get-all # get everything in all namespaces including crds
alias kgaa='kubectl get all --all-namespaces'

# Logs
alias kl='kubectl logs'
alias klg='kubectl get pods --no-headers | fzf | awk '\''{print $1}'\'' | xargs kubectl logs'
alias klgp='kubectl get pods --no-headers | fzf | awk '\''{print $1}'\'' | xargs kubectl logs -p'
alias kl1h='kubectl logs --since 1h'
alias kl1m='kubectl logs --since 1m'
alias kl1s='kubectl logs --since 1s'
alias klf='kubectl logs -f'
alias klf1h='kubectl logs --since 1h -f'
alias klf1m='kubectl logs --since 1m -f'
alias klf1s='kubectl logs --since 1s -f'

# File copy
alias kcp='kubectl cp'

# Node Management
alias kgno='kubectl get nodes'
alias keno='kubectl edit node'
alias kdno='kubectl describe node'
alias kdelno='kubectl delete node'

# PVC management.
alias kgpvc='kubectl get pvc'
alias kgpvca='kubectl get pvc --all-namespaces'
alias kgpvcw='kgpvc --watch'
alias kepvc='kubectl edit pvc'
alias kdpvc='kubectl describe pvc'
alias kdelpvc='kubectl delete pvc'

# Service account management.
alias kdsa="kubectl describe sa"
alias kdelsa="kubectl delete sa"

# DaemonSet management.
alias kgds='kubectl get daemonset'
alias kgdsw='kgds --watch'
alias keds='kubectl edit daemonset'
alias kdds='kubectl describe daemonset'
alias kdelds='kubectl delete daemonset'

# Network policy management.
alias kgnp='kubectl get netpol'
alias kgnpw='kgnp --watch'
alias kenp='kubectl edit netpol'
alias kdnp='kubectl describe netpol'
alias kdelnp='kubectl delete netpol'

# CronJob management.
alias kgcj='kubectl get cronjob'
alias kecj='kubectl edit cronjob'
alias kdcj='kubectl describe cronjob'
alias kdelcj='kubectl delete cronjob'

# Job management.
alias kgj='kubectl get job'
alias kej='kubectl edit job'
alias kdj='kubectl describe job'
alias kdelj='kubectl delete job'

# calico network policies
alias kgnc='kubectl get networkpolicies.crd.projectcalico.org'
alias kdnc='kubectl describe networkpolicies.crd.projectcalico.org'
alias kenc='kubectl edit networkpolicies.crd.projectcalico.org'
alias kdelnc='kubectl delete networkpolicies.crd.projectcalico.org'
alias kgng='kubectl get globalnetworkpolicies.crd.projectcalico.org'
alias kdng='kubectl describe globalnetworkpolicies.crd.projectcalico.org'
alias keng='kubectl edit globalnetworkpolicies.crd.projectcalico.org'
alias kdelng='kubectl delete globalnetworkpolicies.crd.projectcalico.org'
