# local-k8s
local k8s deployment using kind
## Docs

### [Simple Application](./docs/0.simple-application.md)

### [Kind](./kind-config/kind-config.yaml)

### [Ingress Controller Provided By Kind](https://kind.sigs.k8s.io/docs/user/ingress/)

### [LoadBalancer Provided By Kind](https://kind.sigs.k8s.io/docs/user/loadbalancer/)

### [Ingress](./k8s-resources/ingress/default.yaml)

### [Google KMS](./docs/1.gcp-kms-config.md)

### [Vault Auto Unseal Standalone](./docs/2.vault-auto-unseal-config.md)

### [Argocd](./docs/3.argocd.md)

### [Argo Workflows](./docs/4.argo-workflows.md)


# Overview

Purpose of this repo is to test differnet kubernetes technologies on a local cluster. 


## Kind Multi-cluster support

[Issue Link](https://github.com/kubernetes-sigs/kind/issues/2744#issuecomment-1127808069)


Increase `max_user_watches` and `max_user_instances`

```
echo fs.inotify.max_user_watches=655360 | sudo tee -a /etc/sysctl.conf
echo fs.inotify.max_user_instances=1280 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```
