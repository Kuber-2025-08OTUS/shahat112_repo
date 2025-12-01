# Kubernetes Monitoring Homework

Домашнее задание по настройке мониторинга в Kubernetes кластере.

## Компоненты
- Prometheus - сбор метрик
- Grafana - визуализация
- Alertmanager - управление алертами

## Структура каталогов
- `manifests/` - Kubernetes манифесты
  - `prometheus/` - манифесты Prometheus
  - `grafana/` - манифесты Grafana
  - `alertmanager/` - манифесты Alertmanager
- `dashboards/` - дашборды Grafana (JSON)
- `alerts/` - правила алертов Prometheus
- `scripts/` - вспомогательные скрипты
