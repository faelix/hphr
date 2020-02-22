loopback:
    IPv4: "192.0.2.1"
    IPv6: "2001:db8::1"

interfaces:
    eth0:
        bcp38:
            source:
                bgpq3:
                    IPv4: AS-MYNETWORK
                    IPv6: AS-MYNETWORK
        ip:
            ospf:
                passive: True
        ipv6:
            ospfv3:
                passive: True
        netflow: True

    eth1:
        bcp38:
            source:
                bgpq3:
                    IPv4: AS-MYNETWORK
                    IPv6: AS-MYNETWORK
        ip:
            ospf:
                passive: True
        ipv6:
            ospfv3:
                passive: True
        netflow: True

    eth3.1304:
        ip:
            ospf:
                cost: 40
                dead-interval: 40
                hello-interval: 10
                network: broadcast
                priority: 1
                retransmit-interval: 5
                transmit-delay: 1
        ipv6:
            dup-addr-detect-transmits: 1
            ospfv3:
                cost: 40
                dead-interval: 40
                hello-interval: 10
                instance-id: 0
                priority: 1
                retransmit-interval: 5
                transmit-delay: 1

    eth4:
        ip:
            ospf:
                cost: 30
                dead-interval: 40
                hello-interval: 10
                network: point-to-point
                priority: 1
                retransmit-interval: 5
                transmit-delay: 1
        ipv6:
            dup-addr-detect-transmits: 1
            ospfv3:
                cost: 30
                dead-interval: 40
                hello-interval: 10
                instance-id: 0
                priority: 1
                retransmit-interval: 5
                transmit-delay: 1

policy:
    prefix-list:
        auto-AS-APPLE:
            bgpq3:
                IPv4: AS-APPLE
                IPv6: AS-APPLE
        auto-AS-MICROSOFT:
            bgpq3:
                IPv4: AS-MICROSOFT
                IPv6: AS-MICROSOFT
        auto-AS-CLOUDFLARE:
            bgpq3:
                IPv4: AS-CLOUDFLARE
                IPv6: AS-CLOUDFLARE
        auto-AS-EXA:
            bgpq3:
                IPv4: AS-EXA
                IPv6: AS-EXA
        auto-AS5089:
            bgpq3:
                IPv4: AS-NTLI
                IPv6: AS-NTLI

protocols:
    ospf:
        parameters:
            router-id: "192.0.2.1"
        default-information:
            originate:
                metric: 1
                metric-type: 1
        area:
            "0.0.0.0":
                networks:
                    "192.0.2.8/29": {}
                    "198.51.100.0/29": {}
                    "203.0.113.0/24": {}
    ospfv3:
        parameters:
            router-id: "192.0.2.1"
        area:
            "0.0.0.0":
                interface:
                    lo: {}
                    eth0: {}
                    eth1: {}
                    eth3.1304: {}
                    eth4: {}
                range:
                    "2001:db8::1/128": {}
                    "2001:db8:0:1::/64": {}
                    "2001:db8:6:5:4:5:6::/126": {}
                    "2001:db8:203:113::/64": {}

    static:
        route:
            "10.0.0.0/8":
                next-hop:
                    "10.0.0.1": {}
            "0.0.0.0/0":
                blackhole:
                    distance: 10
        route6:
            "::/0":
                blackhole:
                    distance: 10
    bgp:
        4200000000:
            parameters:
                router-id: "192.0.2.1"
            neighbor:
                "192.0.2.2":
                    remote-as: 4200000000
                    description: router2.example.com
                    update-source: 192.0.2.1
                    address-family:
                        ipv4-unicast:
                            allowas-in: 1
                            prefix-list:
                                export: hphr-ALL-IPv4
                                import: hphr-ALL-IPv4
                            soft-reconfiguration:
                                - inbound
                        ipv6-unicast:
                            prefix-list:
                                export: hphr-NO-IPv6
                                import: hphr-NO-IPv6
                "2001:db8::2":
                    remote-as: 4200000000
                    description: router2.example.com
                    update-source: "2001:db8::1"
                    address-family:
                        ipv4-unicast:
                            prefix-list:
                                export: hphr-NO-IPv4
                                import: hphr-NO-IPv4
                        ipv6-unicast:
                            allowas-in: 1
                            prefix-list:
                                export: hphr-ALL-IPv6
                                import: hphr-ALL-IPv6
                            soft-reconfiguration:
                                - inbound

                # TRANSIT

                "198.51.100.1":
                    remote-as: 65551
                    description: AS65551 transit
                    update-source: 198.51.100.2
                    address-family:
                        ipv4-unicast:
                            allowas-in: 1
                            prefix-list:
                                export: auto-AS-MYNETWORK
                                import: hphr-DFZ-IPv4
                            route-map:
                                import: AS65551-in-IPv4
                                export: TRANSIT-out-IPv4
                            soft-reconfiguration:
                                - inbound
                "2001:db8:6:5:4:5:6:1":
                    remote-as: 65551
                    description: AS65551 transit
                    update-source: 2001:db8:6:5:4:5:6:2
                    address-family:
                        ipv6-unicast:
                            allowas-in: 1
                            prefix-list:
                                export: auto-AS-MYNETWORK
                                import: hphr-DFZ-IPv6
                            route-map:
                                import: AS65551-in-IPv6
                                export: TRANSIT-out-IPv6
                            soft-reconfiguration:
                                - inbound

                # PEERING

                "203.0.113.250":
                    remote-as: 65517
                    description: route collector
                    address-family:
                        ipv4-unicast:
                            prefix-list:
                                export: auto-AS4200000000-UK
                                import: hphr-NO-IPv4
                            soft-reconfiguration:
                                - inbound
                "2001:db8:203:113::1":
                    remote-as: 65517
                    description: route collector
                    address-family:
                        ipv6-unicast:
                            prefix-list:
                                export: auto-AS4200000000-UK
                                import: hphr-NO-IPv6
                            soft-reconfiguration:
                                - inbound

                "203.0.113.50":
                    remote-as: 65550
                    description: AS65550 @ Super-DuperIX
                    address-family:
                        ipv4-unicast:
                            allowas-in: 1
                            prefix-list:
                                export: auto-AS-MYNETWORK
                                import: hphr-DFZ-IPv4
                            route-map:
                                import: SUPERDUPERIX-in-IPv4
                                export: TRANSIT-out-IPv4
                            soft-reconfiguration:
                                - inbound
                "2001:db8:203:113::6:5550:1":
                    remote-as: 65550
                    description: AS65550 @ Super-DuperIX
                    address-family:
                        ipv6-unicast:
                            allowas-in: 1
                            prefix-list:
                                export: auto-AS-MYNETWORK
                                import: hphr-DFZ-IPv6
                            route-map:
                                import: SUPERDUPERIX-in-IPv6
                                export: TRANSIT-out-IPv6
                            soft-reconfiguration:
                                - inbound

service:
    lldp:
        management-address: 10.0.0.56
    snmp:
        trap-source: 10.0.0.56
    ssh:
        listen-address: 10.0.0.56

ntp:
    3.pool.ntp.org: {}

control-plane-protection:
    bgp:
        IPv4:
            "192.0.2.8/29": Area0
            "198.51.100.0/29": AS65551 linknet
            "203.0.113.0/24": Super-DuperIX
        IPv6:
            "2001:db8:0:1::/64": Area0
            "2001:db8:6:5:4:5:6::/126": AS65551 linknet
            "2001:db8:203:113::/64": Super-DuperIX
