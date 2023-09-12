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
RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 8084
ENTRYPOINT []
#CMD ["sh", "-c", "while true; do sleep 1; done"]
CMD ["sh", "-c", "nginx && /filebrowser --config /config/settings.json"]