# Use the F-Droid GitLab image as the base
FROM registry.gitlab.com/fdroid/docker-executable-fdroidserver:master

# Set the timezone environment variable (adjust as needed)
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update the system and install python3-pip
RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install python3-pip

# Clone and install a recent version of Androguard
RUN git clone --recursive https://github.com/androguard/androguard.git && \
    cd androguard && \
    git reset --hard v4.1.2 && \
    pip install . --break-system-packages

# (Optional) Initialize and update the F-Droid repository
WORKDIR /fdroid
RUN fdroid init -v && fdroid update

# Install NGINX and curl for Filebrowser
RUN apt-get install -y nginx curl

# Copy NGINX configuration from local settings
COPY ./settings/nginx.conf /etc/nginx/nginx.conf

# Install Filebrowser using the official install script
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Copy Filebrowser configuration files
COPY ./settings/fb-settings.json /usr/local/.fbconfig/settings.json
COPY ./settings/fb-users.json /usr/local/.fbconfig/users.json

# Set the entrypoint and command to launch NGINX and Filebrowser
ENTRYPOINT []
CMD ["bash", "-c", "nginx && /usr/local/bin/filebrowser --config /usr/local/.fbconfig/settings.json"]
