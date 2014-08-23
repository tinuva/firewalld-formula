# == State: firewalld._config
#
# This state configures firewalld.
#

/etc/firewalld/:
  file.directory:            # make sure this is a directory
    - user: root
    - group: root
    - mode: 750
    - require:
      - pkg: firewalld       # make sure package is installed
    - watch_in:
      - service: firewalld   # restart service

/etc/firewalld/firewalld.conf:
  file:
    - managed
    - name: /etc/firewalld/firewalld.conf
    - user: root
    - group: root
    - mode: 640
    - source: salt://firewalld/files/firewalld.conf
    - template: jinja
    - require:
      - pkg: firewalld       # make sure package is installed
    - watch_in: 
      - service: firewalld   # restart service

