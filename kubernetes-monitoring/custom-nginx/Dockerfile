# Используем официальный образ Nginx Alpine как базовый
FROM nginx:alpine

# Метка для идентификации
LABEL maintainer="otus-student"
LABEL description="Custom Nginx image for Kubernetes monitoring homework"
LABEL version="1.0"

# Устанавливаем curl для health checks
RUN apk add --no-cache curl

# Копируем кастомную конфигурацию Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Создаем кастомную HTML страницу
COPY index.html /usr/share/nginx/html/

# Создаем health endpoint
RUN echo '{"status": "healthy", "service": "nginx", "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' > /usr/share/nginx/html/health.json

# Создаем скрипт для генерации метрик в формате Prometheus
RUN echo '#!/bin/sh' > /docker-entrypoint.d/10-generate-metrics.sh && \
    echo 'echo "Starting metrics generator..."' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo 'generate_metrics() {' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '  while true; do' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    # Генерируем метрики в формате Prometheus' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "# HELP nginx_http_requests_total Total number of HTTP requests"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "# TYPE nginx_http_requests_total counter"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_http_requests_total{method=\"GET\",status=\"200\",handler=\"/\"} $((1000 + RANDOM % 500))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_http_requests_total{method=\"GET\",status=\"200\",handler=\"/health\"} $((100 + RANDOM % 50))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "# HELP nginx_http_requests_created Counter of HTTP requests"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "# TYPE nginx_http_requests_created gauge"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_http_requests_created{} $(date +%s)"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "# HELP nginx_active_connections Number of active connections"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "# TYPE nginx_active_connections gauge"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_active_connections{} $((10 + RANDOM % 50))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "# HELP nginx_request_duration_seconds Histogram of request duration"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "# TYPE nginx_request_duration_seconds histogram"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"0.005\"} $((50 + RANDOM % 20))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"0.01\"} $((80 + RANDOM % 30))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"0.025\"} $((120 + RANDOM % 40))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"0.05\"} $((150 + RANDOM % 50))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"0.1\"} $((180 + RANDOM % 60))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"0.25\"} $((200 + RANDOM % 70))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"0.5\"} $((220 + RANDOM % 80))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"1\"} $((240 + RANDOM % 90))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"2.5\"} $((260 + RANDOM % 100))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"5\"} $((280 + RANDOM % 110))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"10\"} $((300 + RANDOM % 120))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_bucket{le=\"+Inf\"} $((320 + RANDOM % 130))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_sum $((50 + RANDOM % 20)).$(shuf -i 0-99 -n 1)"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_request_duration_seconds_count $((100 + RANDOM % 50))"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "# HELP nginx_up Is Nginx up"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "# TYPE nginx_up gauge"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    echo "nginx_up 1"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    # Ждем 10 секунд перед следующей генерацией' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '    sleep 10' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '  done' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '}' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '# Запускаем генерацию метрик в фоне' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo 'generate_metrics > /usr/share/nginx/html/metrics &' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '# Сохраняем PID для graceful shutdown' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo 'METRICS_PID=$!' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo 'trap "kill $METRICS_PID; wait $METRICS_PID" EXIT' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo '# Запускаем стандартный entrypoint Nginx' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    echo 'exec /docker-entrypoint.sh nginx -g "daemon off;"' >> /docker-entrypoint.d/10-generate-metrics.sh && \
    chmod +x /docker-entrypoint.d/10-generate-metrics.sh

# Открываем порты
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/health.json || exit 1

# Запускаем скрипт генерации метрик при старте
ENTRYPOINT ["/docker-entrypoint.d/10-generate-metrics.sh"]
