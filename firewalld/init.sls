
# == State: firewalld
#
# This state installs/runs firewalld.
#


{% if salt['pillar.get']('firewalld:enabled') %}
include:
  - firewalld._config
  - firewalld._service
  - firewalld._zone

# iptables service that comes with rhel/centos
iptables:
  service:
    - disabled
    - enable: False
    
ip6tables:
  service:
    - disabled
    - enable: False

firewalld:
  pkg:
    - installed
  service:
    - running              # ensure it's running
    - enable: True         # start on boot
    - require:
      - pkg: firewalld
      - file: /etc/firewalld/firewalld.conf # require this file
      - service: iptables         # ensure it's stopped
      - service: ip6tables        # ensure it's stopped
{% else %}
firewalld:
  service:
    - dead                 # ensure it's not running
    - enable: False        # don't start on boot
{% endif %}