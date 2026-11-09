FROM python:3.12-alpine AS assets

WORKDIR /site
COPY index.html main.css ./
COPY Assets/ ./Assets/
COPY tools/version-static-assets.py ./tools/version-static-assets.py
RUN python tools/version-static-assets.py

FROM nginxinc/nginx-unprivileged:stable-alpine

COPY --from=assets --chown=nginx:nginx /site/index.html /site/main.css /usr/share/nginx/html/
COPY --from=assets --chown=nginx:nginx /site/Assets/ /usr/share/nginx/html/Assets/
COPY --chown=nginx:nginx sitemap.xml robots.txt llms.txt /usr/share/nginx/html/
COPY --chown=nginx:nginx nginx.conf.template /etc/nginx/templates/default.conf.template

EXPOSE 8080
