# == State: firewalld.backends
#
# This state ensures that /etc/firewalld/backends/ exists.
#
{% from "firewalld/map.jinja" import firewalld with context %}

{%- if salt['pillar.get']('firewalld:installbackend') %}
package_backend:
  pkg.installed:
    - name: {{ firewalld.backendpackage }}
{%- endif %}
