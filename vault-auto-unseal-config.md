# auto-unseal vault config

## review the default helm vault vaules
```sh 
helm show values hashicorp/vault > default-values.yaml
```
## configure a custom vault vaules for google kms (this is for a standalone configuration)
```sh 
  server:
    logLevel: "debug"

    volumes:
      - name: gcp-sa-key
        secret:
          secretName: gcp-sa-key

    volumeMounts:
      - name: gcp-sa-key
        mountPath: /etc/secrets
        readOnly: true

    extraEnvironmentVars:
      GOOGLE_PROJECT: matcham-gke-playground
      GOOGLE_APPLICATION_CREDENTIALS: "/etc/secrets/key.json"

    standalone:
      enabled: true
      config: |-
        ui = true

        listener "tcp" {
          tls_disable = 1
          address = "[::]:8200"
          cluster_address = "[::]:8201"
          # Enable unauthenticated metrics access (necessary for Prometheus Operator)
          #telemetry {
          #  unauthenticated_metrics_access = "true"
          #}
        }
        storage "file" {
          path = "/vault/data"
        }
        seal "gcpckms" {
          project     = "matcham-gke-playground"
          region      = "global"
          key_ring    = "vault-keyring"
          crypto_key  = "vault-key"
        }
```

## helm command to build vault
```sh
helm repo add hasicorp https://helm.releases.hasicorp.com
helm install vault hashicorp/vault -f vault-values.yaml -n vault --create-namespace
```
# connect to vault init and unseal
```sh
kubectl exec -i -t vault-0 -n vault -- bin/sh
```
```sh
vault operator init
```
## use the previously produced root token to login
```sh
vault login $token
```

## enable secrets on vault
```sh
  vault secrets enable kv-v2
```

## enable k8s auth for vault
```sh
  vault auth enable kubernetes
```

## config k8s path
```sh
    vault write auth/kubernetes/config \
      kubernetes_host=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
```

## create a new secret (kv-v2 is the secret path just enabled in previous step)
```sh
  vault kv put kv-v2/vault-local/pod-a-secret secret_name="this is a secrect name"
```

## create a role 
```sh
  vault write auth/kubernetes/role/vault-local \
    bound_service_account_names=vault-local \
    bound_service_account_namespaces=default \
    policies=pod-a-secret \
    ttl=1h
```

## create a policy for secrets
```sh
  vault policy write pod-a-secret - << EOF
  path "kv-v2/data/vault-local/pod-a-secret" {
    capabilities = ["read"]
  }
  EOF
```