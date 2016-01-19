# == State: firewalld._zone
#
# This state ensures that /etc/firewalld/zones/ exists.
#
/etc/firewalld/zones:
  file.directory:            # make sure this is a directory
    - user: root
    - group: root
    - mode: 750
    - require:
      - pkg: firewalld       # make sure package is installed
    - watch_in:
      - service: firewalld   # restart service
      

# == Define: firewalld._zone
#
# This defines a zone configuration, see firewalld.zone (5) man page.
#
{% for k, v in salt['pillar.get']('firewalld:zones', {}).items() %}
{% set z_name = v.name|default(k) %}

/etc/firewalld/zones/{{ z_name }}.xml:
  file:
    - managed
    - name: /etc/firewalld/zones/{{ z_name }}.xml
    - user: root
    - group: root
    - mode: 644
    - source: salt://firewalld/files/zone.xml
    - template: jinja
    - require:
      - pkg: firewalld       # make sure package is installed
    - watch_in: 
      - service: firewalld   # restart service
    - context:
        name: {{ z_name }}
        zone: {{ v }}

{% endfor %}
