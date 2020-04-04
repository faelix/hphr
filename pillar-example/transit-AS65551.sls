policy:
    prefix-list:
        AS65551-in:
            IPv4:
                - match-rpki: invalid
                  action: deny
                - match-prefix-list: hphr-DFZ-IPv4
                  add-community: 65432:64700
                  continue: next
                - match-prefix-list: hphr-DFZ-IPv4
                  set-local-preference: 200
                  add-community: 65432:65551
            IPv6:
                - match-rpki: invalid
                  action: deny
                - match-prefix-list: hphr-DFZ-IPv6
                  add-community: 65432:64700
                  continue: next
                - match-prefix-list: hphr-DFZ-IPv6
                  set-local-preference: 200
                  add-community: 65432:65551

