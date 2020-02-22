![Image of a female moose](hphr-logo.svg)

# Halophile Router (hphr)

The Halophile Router is a [VyOS](https://vyos.io/)-based, [SaltStack](https://github.com/saltstack/)-automated, [NetBox](http://github.com/digitalocean/netbox)-configured router for small provider networks.

The [slides for a short presentation](http://faelix.link/netmcr40) are available by way of explanation of this background to this project.

## Using hphr

You will need:

1. a salt-master server
2. one or more VyOS routers running on amd64 architecture
3. an instance of NetBox
4. a shim module to add some extra data in your Salt pillar from Netbox

## Configuring salt-master

Copy `modules/netbox2.py` into `/home/salt/base/modules` (or similar location as appropriate).  Add and adjust the following `ext_pillar` to your Salt master's configuration:

```
extension_modules: /home/salt/base/modules

ext_pillar:
  - netbox2:
      api_url: https://netbox.example.com/api/
      api_token: f00f00f00f00f00f00f00f00f00f00f00f00f00d
      site_details: True
      site_prefixes: False
      device_interfaces: True
      ip_addresses: True
```

Then copy the contents of `salt/` to your Salt master's `file_roots` (by default this will be `/srv/salt`).

## Configuring your states

You will either need to:

* make a node group called `hphr` via a `node_groups.conf` file

```
nodegroups:
  hphr:
    - router*.example.com
```

* or adjust `salt/top.sls` to be something like:

```
base:
  router*.example.com:
    - hphr
```

## Configuring your pillar

We have included `pillar-example/` to show you how we are using hphr at [FAELIX](https://faelix.net/).  **You will need to customise this heavily for your network.**

## Configuration in Netbox

Your routers will need to exist as devices in Netbox, with the device name matching the system host-name.

### Physical Interfaces

Create physical interfaces in Netbox to match your routers' physical configuration.  Interfaces specified as "management only" will not be deployed to VyOS, and as such are suitable for IPMI, ILO, or other out-of-band management.

Add your IPv4 and IPv6 addresses to the interface as required.  MAC address, MTU, and up/down status are also supported.

### VLANs Tagged on Physical Interfaces

To configure `vif` VLAN sub-interfaces you must ensure that the VLANs are added to the physical interface in Netbox as tagged.  For each such tagged VLAN hphr will search for a virtual interface with the name `ethX.VLAN` (e.g. `eth1.42` for VLAN 42 on `eth1`).

Add addresses to your subinterfaces as required.  Don't forget to tag them on the (real-life) devices that they are connected to.

## Deploying routers

Your router will need to be bootstrapped with basic Internet connectivity.  It will need that connectivity to download a compiled version of [bgpq3](https://github.com/snar/bgpq3), and subsquently fetch data to build your router's prefix-lists.

Then:

```
router1$ configure
router1# set system host-name router1.example.com
router1# set service salt-minion master salt-master.example.com
router1# commit
router1# save
```

You will need to accept the key:

```
salt-master# salt-key -a router1.example.com
salt-master# salt router1.example.com test.ping
router1.example.com:
    True
```

And finally you can deploy the configuration and commit it to the router:

```
salt-master# salt router1.example.com state.highstate
```
