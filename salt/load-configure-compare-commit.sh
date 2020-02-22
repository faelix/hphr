#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
configure
load /config/config.new || exit 1
compare
commit && save || exit 1
exit
