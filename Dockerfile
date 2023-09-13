# build the F-Droid repository
FROM ubuntu
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:fdroid/fdroidserver
RUN apt-get update
RUN apt-get install -y fdroidserver
WORKDIR /fdroid
RUN fdroid init -v
RUN fdroid update
# serve the /repo directory using Filebrowser and NGINX
RUN apt-get install -y nginx curl
RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
COPY settings.json /config/settings.json
ENTRYPOINT []
CMD ["bash", "-c", "nginx && /usr/local/bin/filebrowser --config /config/settings.json"]