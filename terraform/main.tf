## vault root token collection
## requires vault to be initialzed and unsealed
data "vault_generic_secret" "root_token" {
    path = "secret/data/vault-local"
}

provider "vault" {
    address = "http://127.0.0.1:8200"
    token = data.vault_generic_secret.root_token.data["token"]
}

resource "vault_kv_secret_v2" "pod_a_secret" {
    mount = "kv"
    name  = "pod_a_secret"
    path  = "vault-local/pod_a_secret"
    data_json = jsonencode({
        secret_name = "This is a secret stored in Vault"
    })
}

resource "vault_policy" "pod_policy" {
    name = "pod"
    policy = <<EOF
path "kv-v2/data/vault-local/pod_a_secret" {
    capabilities = ["read"]
    }
EOF
}

resource "vault_kubernetes_auth_backend_role" "vault_local" {
    backend = "kubernetes"
    role_name = "vault_local_role"
    bound_service_account_names = ["vault-local"]
    bound_service_account_namespaces = ["default"]
    token_policies = ["pod"]
    token_ttl = "1h"
}
