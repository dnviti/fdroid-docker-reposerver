# First stage: build the F-Droid repository
FROM ubuntu AS build
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:fdroid/fdroidserver
RUN apt-get update
RUN apt-get install -y fdroidserver
WORKDIR /fdroid
RUN fdroid init -v
RUN fdroid update

# Second stage: serve the /repo directory using Filebrowser and NGINX
FROM filebrowser/filebrowser AS final
RUN apk update && apk add nginx
COPY --from=build /fdroid/ /
COPY settings.json /config/settings.json
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8084
CMD ["--config", "/config/settings.json", "&", "nginx", "&", "wait"]