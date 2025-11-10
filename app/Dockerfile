FROM nginx:alpine

COPY . /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

# Create directories and then apply permissions to new user
RUN mkdir -p /var/cache/nginx /var/run/nginx /tmp \
 && chown -R nginx:nginx /var/cache/nginx /var/run/nginx /tmp /etc/nginx/conf.d/default.conf

USER nginx

EXPOSE 80

