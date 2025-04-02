# build the F-Droid repository
FROM ubuntu

# Set the timezone (assumes TZ is provided as an ARG or environment variable)
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install basic packages and add the F-Droid PPA
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:fdroid/fdroidserver && \
    apt-get update && \
    apt-get install -y fdroidserver

### FIX FOR ANDROGUARD VERSION ###
# Update and install Python3 tools, including pip, venv and git
RUN apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get -y install python3-pip python3-venv git

# Create a virtual environment for androguard in /opt/venv
RUN python3 -m venv /opt/venv

# Clone the androguard repository, checkout the specified version, and install it
RUN git clone --recursive https://github.com/androguard/androguard.git && \
    cd androguard && \
    git reset --hard v4.1.2 && \
    /opt/venv/bin/pip install . --break-system-packages --ignore-installed=typing_extensions

# Make the androguard package available to the system Python (used by fdroidserver)
# (Adjust the Python version folder below if your Ubuntu base uses a different version.)
ENV PYTHONPATH="/opt/venv/lib/python3.8/site-packages:${PYTHONPATH}"
### -------------------------- ###

# Set the working directory for F-Droid
WORKDIR /fdroid

# Initialize and update the F-Droid repository
RUN fdroid init -v
RUN fdroid update

# Install NGINX and curl for serving the repository
RUN apt-get install -y nginx curl
COPY ./settings/nginx.conf /etc/nginx/nginx.conf

# Install Filebrowser
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
COPY ./settings/fb-settings.json /usr/local/.fbconfig/settings.json
COPY ./settings/fb-users.json /usr/local/.fbconfig/users.json

# Set the container’s entrypoint and default command
ENTRYPOINT []
CMD ["bash", "-c", "nginx && /usr/local/bin/filebrowser --config /usr/local/.fbconfig/settings.json"]
