#!/bin/bash

echo "=== Kafka Helmfile Installation ==="

# Add bitnami repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Create namespaces
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -

# Install using helmfile
echo "Installing Kafka clusters..."
helmfile sync

echo "=== Installation Complete ==="
echo "Production Kafka (5 brokers, SASL_PLAINTEXT):"
echo "  Namespace: prod"
echo "  Version: 3.5.2"
echo ""
echo "Development Kafka (1 broker, PLAINTEXT):"
echo "  Namespace: dev" 
echo "  Version: latest"
echo ""
echo "Check status with: kubectl get pods -n prod && kubectl get pods -n dev"
