# build the F-Droid repository
FROM ubuntu
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:fdroid/fdroidserver
RUN apt-get update
RUN apt-get install -y fdroidserver
### FIX FOR ANDROGUARD VERSION ###
RUN apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get -y install python3-pip
# we install a recent version of androguard
RUN git clone --recursive https://github.com/androguard/androguard.git && \
    cd androguard && \
    git reset --hard v4.1.2 && \
    pip install . --break-system-packages --ignore-installed=typing_extensions
### -------------------------- ###
WORKDIR /fdroid
RUN fdroid init -v
RUN fdroid update
# serve the /repo directory using Filebrowser and NGINX
RUN apt-get install -y nginx curl
COPY ./settings/nginx.conf /etc/nginx/nginx.conf
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
COPY ./settings/fb-settings.json /usr/local/.fbconfig/settings.json
COPY ./settings/fb-users.json /usr/local/.fbconfig/users.json
ENTRYPOINT []
CMD ["bash", "-c", "nginx && /usr/local/bin/filebrowser --config /usr/local/.fbconfig/settings.json"]
