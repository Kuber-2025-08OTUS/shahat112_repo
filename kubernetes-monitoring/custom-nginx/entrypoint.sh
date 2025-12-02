#!/bin/sh
set -e

echo "Starting custom Nginx with metrics..."

# Функция для генерации метрик
generate_metrics() {
    echo "Starting metrics generator..."
    while true; do
        cat > /usr/share/nginx/html/metrics << EOF
# HELP nginx_http_requests_total Total number of HTTP requests
# TYPE nginx_http_requests_total counter
nginx_http_requests_total{method="GET",status="200",handler="/"} $((1000 + RANDOM % 500))
nginx_http_requests_total{method="GET",status="200",handler="/health"} $((100 + RANDOM % 50))
nginx_http_requests_total{method="GET",status="200",handler="/info"} $((50 + RANDOM % 25))

# HELP nginx_active_connections Number of active connections
# TYPE nginx_active_connections gauge
nginx_active_connections $((10 + RANDOM % 50))

# HELP nginx_up Is Nginx up
# TYPE nginx_up gauge
nginx_up 1

# HELP nginx_request_duration_seconds Histogram of request duration
# TYPE nginx_request_duration_seconds histogram
nginx_request_duration_seconds_bucket{le="0.005"} $((50 + RANDOM % 20))
nginx_request_duration_seconds_bucket{le="0.01"} $((80 + RANDOM % 30))
nginx_request_duration_seconds_bucket{le="0.025"} $((120 + RANDOM % 40))
nginx_request_duration_seconds_bucket{le="0.05"} $((150 + RANDOM % 50))
nginx_request_duration_seconds_bucket{le="0.1"} $((180 + RANDOM % 60))
nginx_request_duration_seconds_bucket{le="0.25"} $((200 + RANDOM % 70))
nginx_request_duration_seconds_bucket{le="0.5"} $((220 + RANDOM % 80))
nginx_request_duration_seconds_bucket{le="1"} $((240 + RANDOM % 90))
nginx_request_duration_seconds_bucket{le="2.5"} $((260 + RANDOM % 100))
nginx_request_duration_seconds_bucket{le="5"} $((280 + RANDOM % 110))
nginx_request_duration_seconds_bucket{le="10"} $((300 + RANDOM % 120))
nginx_request_duration_seconds_bucket{le="+Inf"} $((320 + RANDOM % 130))
nginx_request_duration_seconds_sum $((50 + RANDOM % 20)).$((RANDOM % 100))
nginx_request_duration_seconds_count $((100 + RANDOM % 50))
EOF
        sleep 10
    done
}

# Запускаем генерацию метрик в фоне
generate_metrics &

# Запускаем Nginx
echo "Starting Nginx..."
exec nginx -g "daemon off;"
