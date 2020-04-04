ntp:
    0.pool.ntp.org: {}
    1.pool.ntp.org: {}
    2.pool.ntp.org: {}

nameservers:
    - "9.9.9.9"
    - "1.1.1.1"
    - "2620:fe::fe"
    - "2606:4700:4700::1111"

interfaces:
    lo:
        ip:
            ospf:
                passive: True
        ipv6:
            ospfv3:
                passive: True

netflow:
    sampling-rate: 16
    servers:
        - "10.0.0.246:2055"

policy:
    prefix-list:
        auto-AS-MYNETWORK:
            bgpq3:
                IPv4: AS-MYNETWORK
                IPv6: AS-MYNETWORK

        auto-AS4200000000:
            bgpq3:
                IPv4: AS4200000000
                IPv6: AS4200000000
                most-specific: True

        auto-AS4200000000-UK:
            bgpq3:
                IPv4: RS-AS4200000000-UK
                IPv6: RS-AS4200000000-UK

        auto-AS4200000000-CH:
            bgpq3:
                IPv4: RS-AS4200000000-CH
                IPv6: RS-AS4200000000-CH

    community-list:
        AS4200000000-internal:
            - community: '4200000000:4200000000'
        AS4200000000-upstream:
            - community: '4200000000:64700'
        AS4200000000-peer:
            - community: '4200000000:64701'
        AS4200000000-customer:
            - community: '4200000000:64702'
        AS4200000000-not-to-upstream:
            - community: '4200000000:64600'
        AS4200000000-not-to-peer:
            - community: '4200000000:64601'
        AS4200000000-not-to-customer:
            - community: '4200000000:64602'
        AS4200000000-upstream1:
            - community: '4200000000:174'
        AS4200000000-upstream2:
            - community: '4200000000:3257'
        AS4200000000-upstream3:
            - community: '4200000000:43531'
        AS4200000000-upstream4:
            - community: '4200000000:35425'
        AS4200000000-upstream5:
            - community: '4200000000:6939'
        AS4200000000-upstream6:
            - community: '4200000000:24115'
        AS4200000000-upstream7:
            - community: '4200000000:5459'

    route-map:
        AS4200000000-in:
            IPv4:
                - match-prefix-list: hphr-ALL-IPv4
                  set-community: 4200000000:4200000000
            IPv6:
                - match-prefix-list: hphr-ALL-IPv6
                  set-community: 4200000000:4200000000
        TRANSIT-out:
            IPv4:
                - match-community: AS4200000000-upstream
                  action: deny
                - match-community: AS4200000000-peer
                  action: deny
                - match-community: AS4200000000-upstream1
                  action: deny
                - match-community: AS4200000000-upstream2
                  action: deny
                - match-community: AS4200000000-upstream3
                  action: deny
                - match-community: AS4200000000-upstream4
                  action: deny
                - match-community: AS4200000000-upstream5
                  action: deny
                - match-community: AS4200000000-upstream6
                  action: deny
                - match-community: AS4200000000-upstream7
                  action: deny
                - match-community: AS4200000000-customer
                - match-community: AS4200000000-internal
                - match-prefix-list: auto-AS-MYNETWORK
            IPv6:
                - match-community: AS4200000000-upstream
                  action: deny
                - match-community: AS4200000000-peer
                  action: deny
                - match-community: AS4200000000-upstream1
                  action: deny
                - match-community: AS4200000000-upstream2
                  action: deny
                - match-community: AS4200000000-upstream3
                  action: deny
                - match-community: AS4200000000-upstream4
                  action: deny
                - match-community: AS4200000000-upstream5
                  action: deny
                - match-community: AS4200000000-upstream6
                  action: deny
                - match-community: AS4200000000-upstream7
                  action: deny
                - match-community: AS4200000000-customer
                - match-community: AS4200000000-internal
                - match-prefix-list: auto-AS-MYNETWORK

protocols:
    rpki:
        cache:
            rpki_example_com:
                address: 192.0.2.3
                port: 3323

    bgp:
        4200000000:
            address-family:
                ipv4-unicast:
                    redistribute:
                        static:
                            route-map: AS4200000000-in-IPv4
                    network:
                        "192.0.2.0/24":
                            route-map: AS4200000000-in-IPv4
                ipv6-unicast:
                    redistribute:
                        static:
                            route-map: AS4200000000-in-IPv6
                        connected:
                            route-map: AS4200000000-in-IPv6
                    network:
                        "2001:db8::/48":
                            route-map: AS4200000000-in-IPv6

service:
    lldp:
        interface:
            all: {}
    salt-minion:
        master: salt-master.example.com
    snmp:
        community:
            public: {}
        trap-target:
            "10.0.0.111": {}

sysctl:
    custom:
        net.ipv4.route.max_size: 2097152
        net.ipv6.route.max_size: 262144
        net.ipv4.conf.all.log_martians: 0

users:
    vyos:
        authentication:
            level: admin
            encrypted-password: $6$Nothing$UpMySleeve...AlwaysWorthRemindingYourselfOfTheTwelveNetworkingTruthsEveryOnceInAWhile.
