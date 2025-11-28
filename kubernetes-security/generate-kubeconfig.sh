#!/bin/bash

# Конфигурация
CLUSTER_NAME="kubernetes"
SERVER="https://$(kubectl get endpoints kubernetes -o jsonpath='{.subsets[0].addresses[0].ip}'):6443"
SA_NAME="cd"
NAMESPACE="homework"
CONTEXT_NAME="cd-context"

# Получаем секрет SA
SECRET_NAME=$(kubectl get serviceaccount $SA_NAME -n $NAMESPACE -o jsonpath='{.secrets[0].name}')

# Извлекаем CA и токен
CA_DATA=$(kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath='{.data.ca\.crt}')
TOKEN=$(kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath='{.data.token}' | base64 --decode)

# Создаем kubeconfig
kubectl config set-cluster $CLUSTER_NAME \
  --server=$SERVER \
  --certificate-authority=<(echo $CA_DATA | base64 --decode) \
  --embed-certs=true \
  --kubeconfig=cd-kubeconfig

kubectl config set-credentials $SA_NAME \
  --token=$TOKEN \
  --kubeconfig=cd-kubeconfig

kubectl config set-context $CONTEXT_NAME \
  --cluster=$CLUSTER_NAME \
  --namespace=$NAMESPACE \
  --user=$SA_NAME \
  --kubeconfig=cd-kubeconfig

kubectl config use-context $CONTEXT_NAME --kubeconfig=cd-kubeconfig

echo "Kubeconfig created: cd-kubeconfig"
