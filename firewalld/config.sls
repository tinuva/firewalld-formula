# == State: firewalld._config
#
# This state configures firewalld.
#
{% from "firewalld/map.jinja" import firewalld with context %}

directory_firewalld:
  file.directory:            # make sure this is a directory
    - name: /etc/firewalld
    - user: root
    - group: root
    - mode: 750
    - require:
      - pkg: package_firewalld # make sure package is installed
    - listen_in:
      - module: service_firewalld # restart service

config_firewalld:
  file.managed:
    - name: /etc/firewalld/firewalld.conf
    - user: root
    - group: root
    - mode: 640
    - source: salt://firewalld/files/firewalld.conf
    - template: jinja
    - require:
      - pkg: package_firewalld # make sure package is installed
      - file: directory_firewalld
    - listen_in: 
      - module: service_firewalld # restart service

