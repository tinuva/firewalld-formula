# == State: firewalld.ipsets
#
# This state ensures that /etc/firewalld/ipsets/ exists.
#
{% from "firewalld/map.jinja" import firewalld with context %}

{%- if salt['pillar.get']('firewalld:ipset') %}
package_ipset:
  pkg.installed:
    - name: {{ firewalld.ipsetpackage }}

directory_firewalld_ipsets:
  file.directory:            # make sure this is a directory
    - name: /etc/firewalld/ipsets
    - user: root
    - group: root
    - mode: 750
    - require:
      - pkg: package_firewalld # make sure package is installed
    - require_in:
      - service: service_firewalld
    - watch_in:
      - cmd: reload_firewalld # reload firewalld config

# == Define: firewalld.ipsets
#
# This defines a ipset configuration, see firewalld.ipset (5) man page.
#
{% for k, v in salt['pillar.get']('firewalld:ipsets', {}).items() %}
{% set z_name = v.name|default(k) %}

/etc/firewalld/ipsets/{{ z_name }}.xml:
  file.managed:
    - name: /etc/firewalld/ipsets/{{ z_name }}.xml
    - user: root
    - group: root
    - mode: 644
    - source: salt://firewalld/files/ipset.xml
    - template: jinja
    - require:
      - pkg: package_firewalld # make sure package is installed
      - file: directory_firewalld_ipsets
    - require_in:
      - service: service_firewalld
    - watch_in:
      - cmd: reload_firewalld # reload firewalld config
    - context:
        name: {{ z_name }}
        ipset: {{ v }}

{% endfor %}
{%- endif %}
