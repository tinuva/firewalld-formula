
# == State: firewalld
#
# This state installs/runs firewalld.
#
{% from "firewalld/map.jinja" import firewalld with context %}

{% if salt['pillar.get']('firewalld:enabled') %}
include:
  - firewalld.config
  - firewalld.ipsets
  - firewalld.services
  - firewalld.zones
  - firewalld.direct

# iptables service that comes with rhel/centos
iptables:
  service.disabled:
    - enable: False

ip6tables:
  service.disabled:
    - enable: False

package_firewalld:
  pkg.installed:
    - name: {{ firewalld.package }}

service_firewalld:
  service.running:
    - name: {{ firewalld.service }}
    - enable: True         # start on boot
    - require:
      - pkg: package_firewalld
      - file: config_firewalld
      - service: iptables  # ensure it's stopped
      - service: ip6tables # ensure it's stopped

reload_firewalld:
  cmd.wait:
    - name: 'firewall-cmd --reload'
    - require:
      - service: service_firewalld

{% else %}
service_firewalld:
  service.dead:
    - name: {{ firewalld.service }}
    - enable: False # don't start on boot
{% endif %}
