FROM nginxinc/nginx-unprivileged:stable-alpine

COPY --chown=nginx:nginx index.html main.css /usr/share/nginx/html/
COPY --chown=nginx:nginx Assets/ /usr/share/nginx/html/Assets/
COPY --chown=nginx:nginx nginx.conf.template /etc/nginx/templates/default.conf.template

EXPOSE 8080