# == State: firewalld._service
#
# This state ensures that /etc/firewalld/services/ exists.
#
/etc/firewalld/services:
  file.directory:            # make sure this is a directory
    - user: root
    - group: root
    - mode: 750
    - require:
      - pkg: firewalld       # make sure package is installed
    - watch_in:
      - service: firewalld   # restart service


# == Define: firewalld._service
#
# This defines a service configuration, see firewalld.service (5) man page.
# You usually don't need this, you can simply add ports to zone.

{% for k, v in salt['pillar.get']('firewalld:services', {}).items() %}
{% set s_name = v.name|default(k) %}

/etc/firewalld/services/{{ s_name }}.xml:
  file:
    - managed
    - name: /etc/firewalld/services/{{ s_name }}.xml
    - user: root
    - group: root
    - mode: 644
    - source: salt://firewalld/files/service.xml
    - template: jinja
    - require:
      - pkg: firewalld       # make sure package is installed
    - watch_in: 
      - service: firewalld   # restart service
    - context:
        name: {{ s_name }}
        service: {{ v }}

{% endfor %}
