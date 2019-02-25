ARG OPENRESTY_IMAGE

FROM $OPENRESTY_IMAGE

COPY lua/ /lua/
COPY resty-auth-serve.conf /etc/nginx/conf.d/resty-auth-serve.conf
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

# CMD ["/bin/bash", "-c", "env && /usr/local/openresty/bin/openresty -g 'daemon off;'"]
