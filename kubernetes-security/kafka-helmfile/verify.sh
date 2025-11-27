#!/bin/bash

echo "=== Kafka Cluster Verification ==="

echo "1. Checking production cluster (prod namespace):"
kubectl get pods,svc -n prod -l app.kubernetes.io/name=kafka

echo -e "\n2. Checking development cluster (dev namespace):"
kubectl get pods,svc -n dev -l app.kubernetes.io/name=kafka

echo -e "\n3. Kafka versions:"
echo "Production:"
kubectl exec -n prod kafka-prod-0 -- /bin/bash -c "echo 'version' | kafka-topics.sh --bootstrap-server localhost:9092 --command-config /opt/bitnami/kafka/config/producer.properties" 2>/dev/null || echo "Could not get version - cluster may still be starting"

echo -e "\nDevelopment:"
kubectl exec -n dev kafka-dev-0 -- /bin/bash -c "echo 'version' | kafka-topics.sh --bootstrap-server localhost:9092" 2>/dev/null || echo "Could not get version - cluster may still be starting"

echo -e "\n4. Authentication configuration:"
echo "Production (SASL_PLAINTEXT):"
kubectl exec -n prod kafka-prod-0 -- cat /opt/bitnami/kafka/config/server.properties | grep -E "listeners|sasl"

echo -e "\nDevelopment (PLAINTEXT):"
kubectl exec -n dev kafka-dev-0 -- cat /opt/bitnami/kafka/config/server.properties | grep -E "listeners|sasl"
