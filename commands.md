# helm command to build vault
helm repo add hasicorp https://helm.releases.hasicorp.com
helm install vault hashicorp/vault -n vault --create-namespace

# connect to vault init and unseal
kubectl exec -i -t vault-0 -n vault -- bin/sh

vault operator init


vault operator unseal key 1
vault operator unseal key 2
vault operator unseal key 3 

vault login $token


# enable secrets on vault
vault secrets enable kv-v2

# create a role 
vault write auth/kubernetes/role/vault-local \
  bound_service_account_names=vault-local \
  bound_service_account_namespaces=default \
  policies=pod-a-secret \
  ttl=1h

# create a new secret (kv-v2 is the secret path just enabled in previous step)
vault kv put kv-v2/vault-local/pod-a-secret secret_name="this is a secrect name"

# create a policy for secrets
vault policy write pod-a-secret - << EOF
path "kv-v2/vault-local/pod-a-secret" {
  capabilities = ["read"]
}
EOF

# enable k8s auth for vault
vault auth enable kubernetes

# config k8s path
vault write auth/kubernetes/config \
  kubernetes_host=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
