# This command is used a LOT both below and in daily life
alias k=kubecolor
alias kgg='kubecolor api-resources --no-headers | fzf | awk '\''{print $1}'\'' | xargs kubecolor get'
alias kyg=kubectl-get-yaml-fzf
alias kdg=kubectl-describe-fzf
alias keg=kubectl-edit-fzf
alias kex="kubecolor explain"
alias kexp="kubecolor explore"

alias kcx="kubectx"
alias kns="kubens"
alias kbx="kubie ctx"
alias kbs="kubie ns"
alias kt="kubetail"
alias ky="kyverno"
# Execute a kubecolor command against all namespaces
alias kca='_kca(){ kubecolor "$@" --all-namespaces;  unset -f _kca; }; _kca'

# Generic ones
alias kd="kubecolor describe"
alias ke="kubecolor edit"
alias kg="kubecolor get"
# Apply a YML file
alias kaf='kubecolor apply -f'

# Drop into an interactive terminal on a container
alias keti='kubecolor exec -t -i'

# Manage configuration quickly to switch contexts between local, dev ad staging.
alias kcuc='kubecolor config use-context'
alias kcsc='kubecolor config set-context'
alias kcdc='kubecolor config delete-context'
alias kccc='kubecolor config current-context'
alias kcgc='kubecolor config get-contexts'

# General aliases
alias kdel='kubecolor delete'
alias kdelf='kubecolor delete -f'

# Pod management.
alias kgp='kubecolor get pods'
alias kgpa='kubecolor get pods --all-namespaces'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='kubecolor edit pods'
alias kdp='kubecolor describe pods'
alias kdpp='kubecolor get pods --no-headers | fzf | awk '\''{print $1}'\'' | xargs kubecolor describe pods'
alias kdelp='kubecolor delete pods'
alias kgpall='kubecolor get pods --all-namespaces -o wide'
# get pod by label: kgpl "app=myapp" -n myns
alias kgpl='kgp -l'
# get pod by namespace: kgpn kube-system"
alias kgpn='kgp -n'

# Service management.
alias kgs='kubecolor get svc'
alias kgsa='kubecolor get svc --all-namespaces'
alias kgsw='kgs --watch'
alias kgswide='kgs -o wide'
alias kes='kubecolor edit svc'
alias kds='kubecolor describe svc'
alias kdels='kubecolor delete svc'

# Endpoint management.
alias kge='kubecolor get endpoints'
alias kgea='kubecolor get endpoints --all-namespaces'
alias kgew='kge --watch'
alias kgewide='kge -o wide'
alias kee='kubecolor edit endpoints'
alias kde='kubecolor describe endpoints'
alias kdele='kubecolor delete endpoints'

# Ingress management
alias kgi='kubecolor get ingress'
alias kgia='kubecolor get ingress --all-namespaces'
alias kei='kubecolor edit ingress'
alias kdi='kubecolor describe ingress'
alias kdeli='kubecolor delete ingress'

# Namespace management
alias kgns='kubecolor get namespaces'
alias kens='kubecolor edit namespace'
alias kdns='kubecolor describe namespace'
alias kdelns='kubecolor delete namespace'
alias kcn='kubecolor config set-context --current --namespace'

# ConfigMap management
alias kgcm='kubecolor get configmaps'
alias kgcma='kubecolor get configmaps --all-namespaces'
alias kecm='kubecolor edit configmap'
alias kdcm='kubecolor describe configmap'
alias kdelcm='kubecolor delete configmap'

# Secret management
alias kgsec='kubecolor get secret'
alias kgseca='kubecolor get secret --all-namespaces'
alias kesec='kubecolor edit secret'
alias kdsec='kubecolor describe secret'
alias kdelsec='kubecolor delete secret'

# External secrets
alias kges='kubecolor get es'
alias kgesa='kubecolor get es --all-namespaces'
alias kees='kubecolor describe es'
alias kdes='kubecolor describe es'
alias kdeles='kubecolor delete es'

# Deployment management.
alias kgd='kubecolor get deployment'
alias kgda='kubecolor get deployment --all-namespaces'
alias kgdw='kgd --watch'
alias kgdwide='kgd -o wide'
alias ked='kubecolor edit deployment'
alias kdd='kubecolor describe deployment'
alias kdeld='kubecolor delete deployment'
alias ksd='kubecolor scale deployment'
alias krsd='kubecolor rollout status deployment'

# Run temporary debug pod
alias krd='kubecolor run -it --restart=Never --image=markeijsermans/debug --rm=true'
alias krt='kubecolor run -it --restart=Never --rm=true'

# Rollout management.
alias kgrs='kubecolor get replicaset'
alias kdrs='kubecolor describe replicaset'
alias kers='kubecolor edit replicaset'
alias krh='kubecolor rollout history'
alias kru='kubecolor rollout undo'

# Statefulset management.
alias kgss='kubecolor get statefulset'
alias kgssa='kubecolor get statefulset --all-namespaces'
alias kgssw='kgss --watch'
alias kgsswide='kgss -o wide'
alias kess='kubecolor edit statefulset'
alias kdss='kubecolor describe statefulset'
alias kdelss='kubecolor delete statefulset'
alias ksss='kubecolor scale statefulset'
alias krsss='kubecolor rollout status statefulset'

# Port forwarding
alias kpf="kubecolor port-forward"

# Tools for accessing all information
alias kga='kubecolor get all'
alias kall=kubectl-get-all # get everything in all namespaces including crds
alias kgaa='kubecolor get all --all-namespaces'

# Logs
alias kl='kubecolor logs'
alias klg='kubecolor get pods --no-headers | fzf | awk '\''{print $1}'\'' | xargs kubecolor logs'
alias klgp='kubecolor get pods --no-headers | fzf | awk '\''{print $1}'\'' | xargs kubecolor logs -p'
alias kl1h='kubecolor logs --since 1h'
alias kl1m='kubecolor logs --since 1m'
alias kl1s='kubecolor logs --since 1s'
alias klf='kubecolor logs -f'
alias klf1h='kubecolor logs --since 1h -f'
alias klf1m='kubecolor logs --since 1m -f'
alias klf1s='kubecolor logs --since 1s -f'

# File copy
alias kcp='kubecolor cp'

# Node Management
alias kgno='kubecolor get nodes'
alias keno='kubecolor edit node'
alias kdno='kubecolor describe node'
alias kdelno='kubecolor delete node'

# PVC management.
alias kgpvc='kubecolor get pvc'
alias kgpvca='kubecolor get pvc --all-namespaces'
alias kgpvcw='kgpvc --watch'
alias kepvc='kubecolor edit pvc'
alias kdpvc='kubecolor describe pvc'
alias kdelpvc='kubecolor delete pvc'

# Service account management.
alias kdsa="kubecolor describe sa"
alias kdelsa="kubecolor delete sa"

# DaemonSet management.
alias kgds='kubecolor get daemonset'
alias kgdsw='kgds --watch'
alias keds='kubecolor edit daemonset'
alias kdds='kubecolor describe daemonset'
alias kdelds='kubecolor delete daemonset'

# Network policy management.
alias kgnp='kubecolor get netpol'
alias kgnpw='kgnp --watch'
alias kenp='kubecolor edit netpol'
alias kdnp='kubecolor describe netpol'
alias kdelnp='kubecolor delete netpol'

# CronJob management.
alias kgcj='kubecolor get cronjob'
alias kecj='kubecolor edit cronjob'
alias kdcj='kubecolor describe cronjob'
alias kdelcj='kubecolor delete cronjob'

# Job management.
alias kgj='kubecolor get job'
alias kej='kubecolor edit job'
alias kdj='kubecolor describe job'
alias kdelj='kubecolor delete job'

# calico network policies
alias kgnc='kubecolor get networkpolicies.crd.projectcalico.org'
alias kdnc='kubecolor describe networkpolicies.crd.projectcalico.org'
alias kenc='kubecolor edit networkpolicies.crd.projectcalico.org'
alias kdelnc='kubecolor delete networkpolicies.crd.projectcalico.org'
alias kgng='kubecolor get globalnetworkpolicies.crd.projectcalico.org'
alias kdng='kubecolor describe globalnetworkpolicies.crd.projectcalico.org'
alias keng='kubecolor edit globalnetworkpolicies.crd.projectcalico.org'
alias kdelng='kubecolor delete globalnetworkpolicies.crd.projectcalico.org'

# persistent volumes
alias kgpv='kubecolor get persistentvolume'
alias kepv='kubecolor edit persistentvolume'
alias kdpv='kubecolor describe persistentvolume'
alias kdelpv='kubecolor delete persistentvolume'

# storage classes
alias kgsc='kubecolor get storageclass'
alias kesc='kubecolor edit storageclass'
alias kdsc='kubecolor describe storageclass'
alias kdelsc='kubecolor delete storageclass'
