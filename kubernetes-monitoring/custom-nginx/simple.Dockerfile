# Простой Dockerfile для кастомного Nginx с метриками
FROM nginx:alpine

# Устанавливаем curl для health checks
RUN apk add --no-cache curl

# Копируем конфигурацию Nginx
COPY simple.nginx.conf /etc/nginx/nginx.conf

# Копируем HTML страницу
COPY index.html /usr/share/nginx/html/

# Создаем health endpoint
RUN echo 'healthy' > /usr/share/nginx/html/health

# Создаем скрипт для запуска Nginx и генерации метрик
COPY entrypoint.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/entrypoint.sh

# Открываем порт
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/health || exit 1

# Запускаем через entrypoint скрипт
ENTRYPOINT ["/docker-entrypoint.d/entrypoint.sh"]
