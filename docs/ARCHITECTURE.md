# Architecture

## Four independent data planes

| Exercise | Data-plane object | Expected result |
| --- | --- | --- |
| IPIP namespaces | Linux namespaces, veth pairs, and an IPIP tunnel | An inner namespace packet is carried across the `20.0.0.0/24` underlay. |
| VLAN macvlan | 802.1Q subinterfaces and Docker macvlan networks | Same-VLAN reachability and cross-VLAN isolation. |
| Multicast VXLAN | VNI, multicast group, and VXLAN UDP encapsulation | Overlay delivery is separated from the routed underlay. |
| Docker Swarm | Overlay network, service tasks, and routing mesh | Placement, rescheduling, and service access are distinct behaviours. |

For the IPIP exercise, `red` is `10.10.10.1/24` behind ub1 and `blue` is `10.20.20.1/24` behind ub2. The tunnel endpoints use `172.31.0.1/30` and `172.31.0.2/30` over the `20.0.0.0/24` underlay. The packet path is therefore namespace -> host veth -> IPIP encapsulation -> underlay -> decapsulation -> peer namespace.

The setup scripts use explicit interface, network and address parameters so each exercise can be recreated without relying on saved node state.
