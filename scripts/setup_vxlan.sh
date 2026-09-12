#!/bin/sh
set -eu

: "${PARENT_INTERFACE:=ens3}"
: "${BLUE_VTEP_ADDRESS:?}"
: "${RED_VTEP_ADDRESS:=}"
: "${BLUE_INTERFACE:=blue}"
: "${RED_INTERFACE:=red}"
: "${BLUE_VNI:=33}"
: "${RED_VNI:=66}"
: "${BLUE_GROUP:=239.1.1.3}"
: "${RED_GROUP:=239.1.1.6}"
: "${BLUE_SUBNET:=10.0.0.0/24}"
: "${RED_SUBNET:=11.0.0.0/24}"
: "${BLUE_NETWORK:=bluenet}"
: "${RED_NETWORK:=rednet}"

ip link add "$BLUE_INTERFACE" type vxlan id "$BLUE_VNI" group "$BLUE_GROUP" ttl 5 dev "$PARENT_INTERFACE" dstport 4789 2>/dev/null || true
ip link set "$BLUE_INTERFACE" up
ip address replace "$BLUE_VTEP_ADDRESS" dev "$BLUE_INTERFACE"
if ! docker network inspect "$BLUE_NETWORK" >/dev/null 2>&1; then
    docker network create -d macvlan --subnet="$BLUE_SUBNET" --gateway="${BLUE_VTEP_ADDRESS%/*}" -o parent="$BLUE_INTERFACE" "$BLUE_NETWORK"
fi
if [ -n "$RED_VTEP_ADDRESS" ]; then
    ip link add "$RED_INTERFACE" type vxlan id "$RED_VNI" group "$RED_GROUP" ttl 5 dev "$PARENT_INTERFACE" dstport 4789 2>/dev/null || true
    ip link set "$RED_INTERFACE" up
    ip address replace "$RED_VTEP_ADDRESS" dev "$RED_INTERFACE"
    if ! docker network inspect "$RED_NETWORK" >/dev/null 2>&1; then
        docker network create -d macvlan --subnet="$RED_SUBNET" --gateway="${RED_VTEP_ADDRESS%/*}" -o parent="$RED_INTERFACE" "$RED_NETWORK"
    fi
fi
