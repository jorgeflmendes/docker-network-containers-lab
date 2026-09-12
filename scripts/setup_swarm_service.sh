#!/bin/sh
set -eu

: "${IMAGE:=nginx:alpine}"
: "${SERVICE_NAME:=websvc}"
: "${REPLICAS:=3}"
: "${PUBLISHED_PORT:=8080}"
: "${TARGET_PORT:=80}"

if [ "$(docker info --format '{{.Swarm.LocalNodeState}}')" != active ]; then
    if [ -n "${SWARM_ADVERTISE_ADDR:=}" ]; then
        docker swarm init --advertise-addr "$SWARM_ADVERTISE_ADDR"
    else
        docker swarm init
    fi
fi

if docker service inspect "$SERVICE_NAME" >/dev/null 2>&1; then
    docker service update --image "$IMAGE" --replicas "$REPLICAS" "$SERVICE_NAME"
else
    docker service create --name "$SERVICE_NAME" --replicas "$REPLICAS" --publish published="$PUBLISHED_PORT",target="$TARGET_PORT" "$IMAGE"
fi
