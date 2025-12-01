# Kubernetes Monitoring Homework

## Задание
Настройка системы мониторинга для кастомного Nginx в Kubernetes.

## Выполненные задачи

### 1. Кастомный образ Nginx
- Создан Docker образ `custom-nginx:simple`
- Образ включает:
  - Nginx с кастомной конфигурацией
  - Endpoint `/metrics` с метриками в формате Prometheus
  - Endpoint `/health` для health checks
  - Healthcheck в Docker
  - Генератор метрик

### 2. Метрики
Образ экспортирует следующие метрики:
- `nginx_http_requests_total` - общее количество HTTP запросов
- `nginx_active_connections` - активные соединения
- `nginx_up` - статус доступности
- `nginx_request_duration_seconds` - гистограмма времени выполнения запросов

### 3. Kubernetes манифесты
- Deployment с 2 репликами Nginx
- Service для доступа к Nginx
- Liveness и readiness probes

### 4. Prometheus Operator
- Установлен через Helm chart `kube-prometheus-stack`
- Включает Prometheus, Grafana, Alertmanager

### 5. ServiceMonitor
- ServiceMonitor для автоматического обнаружения и сбора метрик с Nginx
- Интервал сбора: 15 секунд

## Структура проекта

kubernetes-monitoring/
├── custom-nginx/ # Кастомный образ Nginx
│ ├── Dockerfile
│ ├── simple.Dockerfile
│ ├── simple.nginx.conf
│ ├── entrypoint.sh
│ ├── index.html
│ └── simple-index.html
├── manifests/ # Kubernetes манифесты
│ ├── nginx/
│ │ └── nginx-deployment.yaml
│ └── prometheus-operator/
│ ├── install.sh
│ └── nginx-servicemonitor.yaml
├── scripts/ # Скрипты
│ └── deploy-all.sh
└── README.md
