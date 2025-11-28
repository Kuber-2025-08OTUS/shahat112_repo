# Redis Setup Instructions

Due to repository access issues, Redis needs to be installed separately:

## Option 1: Install Redis using Helm (if repository works)
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install redis bitnami/redis --namespace homework --set auth.enabled=false
