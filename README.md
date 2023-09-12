# F-Droid Repo Server with Filebrowser

Docker Hub Pre-Built image: [fdroid-reposerver](https://hub.docker.com/r/dnviti/fdroid-reposerver)
You can also use the `docker-compose-deploy.yaml` from here to automate the process.

This Dockerfile creates a Docker image that deploys an F-Droid repository server using Alpine Linux and serves the `/repo` directory using Filebrowser with authentication.

## Overview

The Dockerfile consists of two stages:

1. **Build stage**: In this stage, the F-Droid repository is built using Alpine Linux. The necessary packages and tools for the F-Droid server and Android SDK are installed, and the F-Droid repository is initialized and updated.

2. **Filebrowser stage**: In this stage, the `/repo` directory from the build stage is served using Filebrowser with authentication. The `settings.json` file is used to configure Filebrowser, and the authentication is handled using a `users.json` file.

## Usage

1. Create a .env file specifying the Timezone (E.g. TZ=Europe/Rome)

2. Create a `settings.json` file with the desired Filebrowser settings, including the authentication method and the path to the `users.json` file.

3. Create a `users.json` file with the desired user credentials and permissions.

4. Place your custom apps (APK files) in the `/repo` directory.

5. Build the Docker image using the provided Dockerfile: `docker build -t fdroid-repo-server .` (you can also use `docker compose build` to use the default settings

6. Run a container using the built image: `docker run -d -p 80:80 --name fdroid-repo-server fdroid-repo-server`

7. Access the Filebrowser web interface at `http://localhost` (or the appropriate IP address) and log in with the credentials specified in the `users.json` file.

8. Share the F-Droid repository URL with your users. The URL should be in the format `http://<your-server-ip>/repo`.

9. Default username and password is admin/admin (please change the password at first configuration)

## Customization

You can modify the Dockerfile and the `settings.json` and `users.json` files according to your specific requirements. For more information on Filebrowser settings and authentication methods, refer to the [Filebrowser documentation](https://filebrowser.org/configuration/authentication-method).


## Credits

- [FileBrowser](https://github.com/filebrowser) for his amazing work, more details at [filebrowser.org](https://filebrowser.org/)
- [F-Droid](https://f-droid.org/it/) for the amazing open source repo app store
