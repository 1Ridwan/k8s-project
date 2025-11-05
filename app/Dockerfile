FROM nginx:alpine

COPY ./ /usr/share/nginx/html

RUN chown -R nginx:nginx /usr/share/nginx/html

USER nginx

EXPOSE 80
