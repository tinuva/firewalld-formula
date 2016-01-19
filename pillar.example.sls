# CentOS7 FirewallD firewall
firewalld:
  enabled: True
  default_zone: public
  services:
    sshcustom:
      short: sshcustom
      description: SSH on port 3232 and 5252. Secure Shell (SSH) is a protocol for logging into and executing commands on remote machines. It provides secure encrypted communications. If you plan on accessing your machine remotely via SSH over a firewalled interface, enable this option. You need the openssh-server package installed for this option to be useful.
      ports:
        tcp: 
          - 3232
          - 5252
      modules: 
        - some_module_to_load
      destinations:
        ipv4: 
          - 224.0.0.251
          - 224.0.0.252
        ipv6: 
          - ff02::fb
          - ff02::fc
  zones:
    public:
      short: Public
      description: "For use in public areas. You do not trust the other computers on networks to not harm your computer. Only selected incoming connections are accepted."
      services:
        - http
        - https
        - ssh
        - dhcpv6-client

