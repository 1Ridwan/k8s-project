FROM nginx:alpine

COPY ./ /usr/share/nginx/html

USER nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

