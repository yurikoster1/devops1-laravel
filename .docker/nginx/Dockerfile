#@version 3.7.5

FROM nginx:1.19.1-alpine
MAINTAINER Yuri Koster <yurikoster1@gmail.com>

EXPOSE 80
EXPOSE 443

#RUN rm -r /var/www/html
RUN rm /etc/nginx/conf.d/default.conf

COPY ./entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]