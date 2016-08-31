FROM nginx:1.10-alpine

COPY html/ /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
ARG BUILD_NUMBER
RUN echo "<HTML><BODY>BUILD_NUMBER: $BUILD_NUMBER</BODY></HTML>" > /usr/share/nginx/html/version.html