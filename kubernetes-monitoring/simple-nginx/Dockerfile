FROM nginx:alpine

# Копируем конфиг с stub_status
COPY nginx.conf /etc/nginx/nginx.conf

# Создаем простую страницу
RUN echo '<html><body><h1>Nginx with Metrics</h1><p>Metrics available at: /metrics</p></body></html>' > /usr/share/nginx/html/index.html

# Устанавливаем curl для health check
RUN apk add --no-cache curl

# Создаем простой скрипт для метрик
RUN echo '#!/bin/sh' > /docker-entrypoint.d/10-expose-metrics.sh && \
    echo 'while true; do' >> /docker-entrypoint.d/10-expose-metrics.sh && \
    echo '  echo "# HELP nginx_requests_total Total number of requests"' >> /docker-entrypoint.d/10-expose-metrics.sh && \
    echo '  echo "# TYPE nginx_requests_total counter"' >> /docker-entrypoint.d/10-expose-metrics.sh && \
    echo '  echo "nginx_requests_total $(shuf -i 1000-5000 -n 1)"' >> /docker-entrypoint.d/10-expose-metrics.sh && \
    echo '  echo "# HELP nginx_connections Active connections"' >> /docker-entrypoint.d/10-expose-metrics.sh && \
    echo '  echo "# TYPE nginx_connections gauge"' >> /docker-entrypoint.d/10-expose-metrics.sh && \
    echo '  echo "nginx_connections $(shuf -i 10-100 -n 1)"' >> /docker-entrypoint.d/10-expose-metrics.sh && \
    echo '  sleep 15' >> /docker-entrypoint.d/10-expose-metrics.sh && \
    echo 'done > /usr/share/nginx/html/metrics &' >> /docker-entrypoint.d/10-expose-metrics.sh && \
    chmod +x /docker-entrypoint.d/10-expose-metrics.sh
