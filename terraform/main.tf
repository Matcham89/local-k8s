provider "vault" {
    address = "http://127.0.0.1:8200"
    token = var.vault_token
}

resource "vault_kv_secret_v2" "pod_a_secret" {
    mount = "kv"
    name  = "pod_a_secret"
    path  = "vault-local/pod_a_secret"
    data_json = jsonencode({
        secret_name = "This is a secret stored in Vault"
    })
}

resource "vault_policy" "pod_a_secret_policy" {
    name = "pod_a_secret_policy"
    policy = <<EOF
path "kv-v2/data/vault-local/pod_a_secret" {
    capabilities = ["read"]
    }
EOF
}

