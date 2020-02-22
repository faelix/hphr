#!/bin/sh

ipset destroy tmp-bcp38-cone-oface-v4 2> /dev/null || /bin/true
ipset destroy tmp-bcp38-else-oface-v4 2> /dev/null || /bin/true
ipset destroy tmp-bcp38-cone-oface-v6 2> /dev/null || /bin/true
ipset destroy tmp-bcp38-else-oface-v6 2> /dev/null || /bin/true
ipset create bcp38-cone-oface-v4 hash:net,iface family inet hashsize 1024 maxelem 65536 2> /dev/null || /bin/true
ipset create bcp38-else-oface-v4 hash:net,iface family inet hashsize 1024 maxelem 65536 2> /dev/null || /bin/true
ipset create bcp38-cone-oface-v6 hash:net,iface family inet6 hashsize 1024 maxelem 65536 2> /dev/null || /bin/true
ipset create bcp38-else-oface-v6 hash:net,iface family inet6 hashsize 1024 maxelem 65536 2> /dev/null || /bin/true

ipset destroy tmp-control-plane-bgp-v4 2> /dev/null || /bin/true
ipset destroy tmp-control-plane-bgp-v6 2> /dev/null || /bin/true
ipset create control-plane-bgp-v4 hash:net family inet hashsize 1024 maxelem 65536 2> /dev/null || /bin/true
ipset create control-plane-bgp-v6 hash:net family inet6 hashsize 1024 maxelem 65536 2> /dev/null || /bin/true

ipset restore < /config/hphr.ipset

iptables-restore /config/hphr.rules.v4
ip6tables-restore /config/hphr.rules.v6
