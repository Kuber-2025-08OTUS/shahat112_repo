#!/bin/bash
set -e

echo "=== Deploying Kubernetes Monitoring Homework ==="

echo "1. Loading custom Nginx image to Minikube..."
minikube image load custom-nginx:simple

echo "2. Deploying custom Nginx..."
kubectl apply -f manifests/nginx/nginx-deployment.yaml

echo "3. Installing Prometheus Operator..."
./manifests/prometheus-operator/install.sh

echo "4. Waiting for Prometheus Operator to be ready..."
sleep 30

echo "5. Configuring ServiceMonitor for Nginx..."
kubectl apply -f manifests/prometheus-operator/nginx-servicemonitor.yaml

echo "6. Verifying deployment..."
echo ""
echo "=== Verification ==="
echo "Nginx pods:"
kubectl get pods -l app=custom-nginx

echo ""
echo "ServiceMonitor:"
kubectl get servicemonitor -n monitoring

echo ""
echo "=== Access Information ==="
echo "1. Nginx Service:"
echo "   kubectl get svc custom-nginx"
echo "   curl http://<cluster-ip>/metrics"
echo ""
echo "2. Prometheus UI:"
echo "   kubectl port-forward svc/prometheus-operated 9090 -n monitoring"
echo "   Then open: http://localhost:9090"
echo ""
echo "3. Grafana:"
echo "   kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring"
echo "   Then open: http://localhost:3000"
echo "   Login: admin / admin123"
echo ""
echo "4. Check if Prometheus is scraping Nginx metrics:"
echo "   In Prometheus UI, query: up{service=\"custom-nginx\"}"
echo "   Should return 1"
