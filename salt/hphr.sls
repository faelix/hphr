/tmp/bgpq3:
  file.managed:
    - source: https://pkg.faelix.net/hphr-debian10-amd64-bgpq3
    - source_hash: sha256=c676ddad4d1debb7c04e77625f587ba1795f64751b7e3273fad5e5614e6be018
    - mode: 755

/tmp/bind.so:
  file.managed:
    - source: https://pkg.faelix.net/hphr-debian10-amd64-bind.so
    - source_hash: sha256=47381b873d8993ad980f28b595eda9caea4be7ef7019c06484ce38c57fa0991e
    - mode: 755

/config/config.new:
  file.managed:
    - template: jinja
    - source: salt://vyos.conf.j2
    - mode: 644
    - require:
      - file: /tmp/bgpq3
      - file: /tmp/bind.so

configure:
  cmd.script:
    - source: salt://load-configure-compare-commit.sh
    - shell: /bin/vbash
    - runas: minion
    - require:
      - file: /config/config.new

/config/hphr.rules.v4:
  file.managed:
    - template: jinja
    - source: salt://bcp38.iptables.v4

/config/hphr.rules.v6:
  file.managed:
    - template: jinja
    - source: salt://bcp38.iptables.v6

/config/hphr.ipset:
  file.managed:
    - template: jinja
    - source: salt://bcp38.ipset.j2

chmod /config/scripts/vyos-postconfig-bootup.script:
  cmd.run:
    - name: sudo chmod 760 /config/scripts/vyos-postconfig-bootup.script

/config/scripts/vyos-postconfig-bootup.script:
  file.managed:
    - template: jinja
    - source: salt://postconfig.sh
    - mode: 760
    - require:
      - cmd: chmod /config/scripts/vyos-postconfig-bootup.script
      - file: /config/hphr.rules.v4
      - file: /config/hphr.rules.v6
      - file: /config/hphr.ipset
  cmd.run:
    - name: sudo /config/scripts/vyos-postconfig-bootup.script
    - require:
      - file: /config/scripts/vyos-postconfig-bootup.script
      - cmd: configure
