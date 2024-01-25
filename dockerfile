FROM docker/compose:alpine-1.29.2

WORKDIR /app

COPY virtualization/docker/docker-compose/docker-compose.yaml .