# Stage 1
FROM ubuntu:latest AS build

# Install the Hugo go app.
RUN apt update && apt install wget git -y && wget -O /tmp/hugo.deb https://github.com/gohugoio/hugo/releases/download/v0.125.5/hugo_extended_0.125.5_linux-amd64.deb && dpkg -i /tmp/hugo.deb
#RUN snap install dart-sass
#RUN [[ -f package-lock.json || -f npm-shrinkwrap.json ]] && npm ci || true

WORKDIR /opt/HugoApp

# Copy Hugo config into the container Workdir.
COPY . .

# Run Hugo in the Workdir to generate HTML.
RUN hugo 

# Stage 2
FROM nginx:1.25-alpine

# Set workdir to the NGINX default dir.
WORKDIR /usr/share/nginx/html

# Copy HTML from previous build into the Workdir.
COPY --from=build /opt/HugoApp/public .

# Expose port 80
EXPOSE 80/tcp
