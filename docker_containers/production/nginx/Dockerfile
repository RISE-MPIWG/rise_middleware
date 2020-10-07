FROM nginx:alpine

MAINTAINER pbelouin
COPY nginx.conf /etc/nginx/nginx.conf
COPY dh.pem   /etc/ssl/dh.pem
COPY rise.pem /etc/ssl/rise.pem
COPY rise.csr /etc/ssl/rise.csr
COPY rise.key /etc/ssl/rise.key
CMD [ "nginx", "-g", "daemon off;" ]