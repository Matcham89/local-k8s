# google kms configuration
## set google project
```sh
export PROJECT_ID=$(gcloud config get-value project)
```

## enable google project api
```sh 
gcloud services enable cloudkms.googleapis.com
gcloud services enable cloudkms.googleapis.com
```
## create google service account
```sh
gcloud iam service-accounts create vault-sa \
    --description="Vault Service Account for GCP KMS" \
    --display-name="Vault GCP KMS Service Account"
```
## bind service account to permissions

```sh 
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:vault-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/cloudkms.cryptoKeyEncrypterDecrypter"
```
```sh 
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:vault-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/cloudkms.viewer"
```

## create and download json key
```sh 
gcloud iam service-accounts keys create ./vault-sa-key.json \
    --iam-account vault-sa@$PROJECT_ID.iam.gserviceaccount.com
```

## create k8s secret with json key value
```sh 
kubectl create secret generic gcp-sa-key \
    --from-file=key.json=./vault-sa-key.json \
    --namespace vault
```
## create google cloud kms key & keyring
```sh 
gcloud kms keyrings create vault-keyring --location global
gcloud kms keys create vault-key --location global --keyring vault-keyring --purpose encryption
```

## bind the service account to the keyring
```sh 
gcloud kms keys add-iam-policy-binding vault-key \
    --location global \
    --keyring vault-keyring \
    --member "serviceAccount:vault-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role roles/cloudkms.cryptoKeyEncrypterDecrypter
```