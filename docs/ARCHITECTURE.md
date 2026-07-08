# Architecture Notes - Docker Network Containers Lab

## Lab Topology

The lab uses three Ubuntu/Linux GNS3 nodes and a router underlay. It demonstrates IPIP tunnels between namespaces, VLAN-backed macvlan networks, multicast VXLAN overlays, and Docker Swarm overlay/routing-mesh behavior.

## Evidence Flow

Linux command outputs, Docker command outputs, screenshots, and tshark CSV/text summaries are included. Raw captures and course handouts are excluded.

## Publication Boundary

The repository keeps report source and selected reviewed evidence. It deliberately excludes:

- raw PCAP files
- Docker image layers
- course lab guide PDFs
- GNS3 project IDs
- temporary debug logs

## Reproduction Assumptions

The lab was executed in GNS3 using Cisco/GNS3 appliances and Linux containers. Re-running the full topology requires local access to those appliances and the original lab guide. The portable CI only validates repository hygiene.
