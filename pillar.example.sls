# FirewallD pillar examples:
firewalld:
  enabled: True
  ipset: True
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

    zabbixcustom:
      short: Zabbixcustom
      description: "zabbix custom rule"
      ports:
        tcp:
          - "10051"
    salt-minion:
      short: salt-minion
      description: "salt-minion"
      ports:
        tcp:
          - "8000"

  ipsets:
    fail2ban-ssh:
      short: fail2ban-ssh
      description: fail2ban-ssh ipset
      type: 'hash:ip'
      options:
        maxelem:
          - 65536
        timeout:
          - 300
        hashsize:
          - 1024
      entries:
        - 10.0.0.1


  zones:
    public:
      short: Public
      description: "For use in public areas. You do not trust the other computers on networks to not harm your computer. Only selected incoming connections are accepted."
      services:
        - http
        - zabbixcustom
        - https
        - ssh
        - salt-minion
      rich_rules:
        - family: ipv4
          source:
              address: 8.8.8.8/24
          accept: true
        - family: ipv4
          ipset:
            name: fail2ban-ssh
          reject:
            type: icmp-port-unreachable
      ports:
{% if grains['id'] == 'salt.example.com' %}
        - comment: salt-master
          port: 4505
          protocol: tcp
        - comment: salt-python
          port: 4506
          protocol: tcp
{% endif %}
        - comment: zabbix-agent
          port: 10050
          protocol: tcp
        - comment: bacula-client
          port: 9102
          protocol: tcp
        - comment: vsftpd
          port: 21
          protocol: tcp

  direct:
    chain:
      MYCHAIN:
        ipv: ipv4
        table: raw
    rule:
      INTERNETACCESS:
        ipv: ipv4
        table: filter
        chain: FORWARD
        priority: "0"
        args: "-i iintern -o iextern -s 192.168.1.0/24 -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT"
    passthrough:
      MYPASSTHROUGH:
        ipv: ipv4
        args: "-t raw -A MYCHAIN -j DROP"

