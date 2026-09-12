#!/bin/sh
set -eu

: "${NAMESPACE:?}"
: "${NAMESPACE_ADDRESS:?}"
: "${HOST_ADDRESS:?}"
: "${TUNNEL_NAME:?}"
: "${TUNNEL_ADDRESS:?}"
: "${LOCAL_UNDERLAY:?}"
: "${REMOTE_UNDERLAY:?}"
: "${REMOTE_NETWORK:?}"

VETH_NAMESPACE="veth-${NAMESPACE}"
VETH_HOST="${VETH_NAMESPACE}-host"
ip netns add "$NAMESPACE"
ip link add "$VETH_NAMESPACE" type veth peer name "$VETH_HOST"
ip link set "$VETH_NAMESPACE" netns "$NAMESPACE"
ip -n "$NAMESPACE" address add "$NAMESPACE_ADDRESS" dev "$VETH_NAMESPACE"
ip -n "$NAMESPACE" link set "$VETH_NAMESPACE" up
ip address add "$HOST_ADDRESS" dev "$VETH_HOST"
ip link set "$VETH_HOST" up
ip tunnel add "$TUNNEL_NAME" mode ipip local "$LOCAL_UNDERLAY" remote "$REMOTE_UNDERLAY"
ip address add "$TUNNEL_ADDRESS" dev "$TUNNEL_NAME"
ip link set "$TUNNEL_NAME" up
ip route replace "$REMOTE_NETWORK" dev "$TUNNEL_NAME"
ip -n "$NAMESPACE" route replace default via "${HOST_ADDRESS%/*}"
sysctl -w net.ipv4.ip_forward=1
