#!/bin/bash
echo "=== Installing Prometheus Operator ==="

# Создаем namespace для мониторинга
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Добавляем Helm репозиторий
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Устанавливаем kube-prometheus-stack
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set grafana.adminPassword=admin123 \
  --set prometheus.service.type=NodePort \
  --set grafana.service.type=NodePort \
  --wait

echo "=== Prometheus Operator installed successfully ==="
echo ""
echo "Access URLs:"
echo "Prometheus:  kubectl port-forward svc/prometheus-operated 9090 -n monitoring"
echo "Grafana:     kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring"
echo "Grafana credentials: admin / admin123"
