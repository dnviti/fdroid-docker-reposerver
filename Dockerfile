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

# Second stage: serve the /repo directory using Filebrowser
FROM filebrowser/filebrowser AS final
COPY --from=build /fdroid/ /
COPY settings.json /config/settings.json
CMD ["--config", "/config/settings.json"]