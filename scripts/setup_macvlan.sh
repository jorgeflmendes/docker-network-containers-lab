#!/bin/sh
set -eu

: "${PARENT_INTERFACE:=ens3}"
: "${BLUE_VLAN:=10}"
: "${RED_VLAN:=20}"
: "${BLUE_SUBNET:=10.60.10.0/24}"
: "${RED_SUBNET:=10.60.20.0/24}"
: "${BLUE_NETWORK:=bluevlan}"
: "${RED_NETWORK:=redvlan}"

for vlan in "$BLUE_VLAN" "$RED_VLAN"; do
    ip link add link "$PARENT_INTERFACE" name "$PARENT_INTERFACE.$vlan" type vlan id "$vlan" 2>/dev/null || true
    ip link set "$PARENT_INTERFACE.$vlan" up
done

if ! docker network inspect "$BLUE_NETWORK" >/dev/null 2>&1; then
    docker network create -d macvlan --subnet="$BLUE_SUBNET" -o parent="$PARENT_INTERFACE.$BLUE_VLAN" "$BLUE_NETWORK"
fi
if ! docker network inspect "$RED_NETWORK" >/dev/null 2>&1; then
    docker network create -d macvlan --subnet="$RED_SUBNET" -o parent="$PARENT_INTERFACE.$RED_VLAN" "$RED_NETWORK"
fi
