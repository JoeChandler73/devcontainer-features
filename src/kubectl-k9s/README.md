
# kubectl-k9s (kubectl-k9s)

Installs kubectl and k9s for Kubernetes management

## Example Usage

```json
"features": {
    "ghcr.io/JoeChandler73/devcontainer-features/kubectl-k9s:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| kubectlVersion | Version of kubectl to install (e.g., 'v1.28.0' or 'latest') | string | latest |
| k9sVersion | Version of k9s to install (e.g., 'v0.32.4' or 'latest') | string | latest |
| installKubectx | Install kubectx and kubens utilities for context/namespace switching | boolean | true |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/JoeChandler73/devcontainer-features/blob/main/src/kubectl-k9s/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
