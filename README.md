# local-k8s
local k8s deployment using kind
## Configurations

### [Vault Auto Unseal Standalone](./docs/vault-auto-unseal-config.md)

### [Google KMS](./docs/gcp-kms-config.md)

### [Kind](./kind-config/kind-config.yaml)

### [Ingress](./k8s-resources/ingress.yaml)

### [LoadBalancer Provided By Kind](https://kind.sigs.k8s.io/docs/user/loadbalancer/)
command: ```cloud-provider-kind```

### [Ingress Controller Provided By Kind](https://kind.sigs.k8s.io/docs/user/ingress/)

## Test Application - Python Flask Web App

### Overview

This is a simple Flask web application that displays an `APP_MESSAGE`, a Vault secret (`SECRET`), and another environment variable (`OTHER_SECRET`) on a web page. The application is designed to be configurable via environment variables, which can be set to customize the displayed messages and secrets.

### Features

- Displays a customizable message using the `APP_MESSAGE` environment variable.
- Displays a Vault secret named `SECRET_NAME` and another environment variable `OTHER_SECRET`.
- Uses Flask to serve a web page rendered with a simple HTML template.

### Prerequisites

- Python 3.6 or later
- Flask package
- Environment variables configured for the `APP_MESSAGE`, `SECRET_NAME`, and `OTHER_SECRET`

### Environment Variables

The following environment variables must be set before running the application:

- `APP_MESSAGE`: This is pulled from the deployment vairables.  
- `SECRET`: The Vault secret value (default: `"Not Connected"`).
- `OTHER_SECRET`: An additional secret value (default: `"Not Set"`).


### Example Output

```
Application-A
---------------
Hello from Application A!
Vault Secret: My Secret Value
Other Secret: Another Secret
``` 
