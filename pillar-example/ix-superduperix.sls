policy:
    prefix-list:
        SUPERDUPERIX-in:
            IPv4:
                - match-rpki: invalid
                  action: deny
                - match-prefix-list: hphr-DFZ-IPv4
                  set-community: 65432:64701
                  continue: next
                - match-prefix-list: hphr-DFZ-IPv4
                  set-local-preference: 600
                  set-community: 65432:5459
            IPv6:
                - match-rpki: invalid
                  action: deny
                - match-prefix-list: hphr-DFZ-IPv6
                  set-community: 65432:64702
                  continue: next
                - match-prefix-list: hphr-DFZ-IPv6
                  set-local-preference: 600
                  set-community: 65432:5459

        SUPERDUPERIX-RS-in:
            IPv4:
                - match-rpki: invalid
                  action: deny
                - match-prefix-list: hphr-DFZ-IPv4
                  set-community: 65432:64701
                  continue: next
                - match-prefix-list: hphr-DFZ-IPv4
                  set-local-preference: 550
                  set-community: 65432:5459
            IPv6:
                - match-rpki: invalid
                  action: deny
                - match-prefix-list: hphr-DFZ-IPv6
                  set-community: 65432:64702
                  continue: next
                - match-prefix-list: hphr-DFZ-IPv6
                  set-local-preference: 550
                  set-community: 65432:5459
