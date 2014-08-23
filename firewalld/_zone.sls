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



# === Parameters
#
# [*target*]		can be one of {'ACCEPT', '%%REJECT%%', 'DROP'}.
#			Used to accept, reject or drop every packet that
#			doesn't match any rule (port, service, etc.).
#			Default (when target is not specified) is reject.
# [*short*]		short readable name
# [*description*]	long description of zone
# [*interfaces*]	list of interfaces to bind to a zone
# [*sources*]		list of source addresses or source address
#			ranges ("address/mask") to bind to a zone
# [*ports*]
#   list of ports to open
#	ports  => [{
#		comment  => optional, string
#		port     => mandatory, string, e.g. '1234'
#		protocol => mandatory, string, e.g. 'tcp' },...]
# [*services*]		list of predefined firewalld services
# [*icmp_blocks*]	list of predefined icmp-types to block
# [*masquerade*]	enable masquerading ?
# [*forward_ports*]
#   list of ports to forward to other port and/or machine
#	forward_ports  => [{
#		comment  => optional, string
#		portid   => mandatory, string, e.g. '123'
#		protocol => mandatory, string, e.g. 'tcp'
#		to_port  => mandatory to specify either to_port or/and to_addr
#		to_addr  => mandatory to specify either to_port or/and to_addr },...]
# [*rich_rules*]
#   list of rich language rules (firewalld.richlanguage(5))
#	You have to specify one (and only one)
#	of {service, port, protocol, icmp_block, masquerade, forward_port}
#	and one (and only one) of {accept, reject, drop}
#	family - 'ipv4' or 'ipv6', optional, see Rule in firewalld.richlanguage(5)
#	source  => {  optional, see Source in firewalld.richlanguage(5)
#		address  => mandatory, string, e.g. '192.168.1.0/24'
#		invert   => optional, bool, e.g. true }
#	destination => { optional, see Destination in firewalld.richlanguage(5)
#		address => mandatory, string
#		invert  => optional, bool, e.g. true }
#	service - string, see Service in firewalld.richlanguage(5)
#	port => { see Port in firewalld.richlanguage(5)
#		portid   => mandatory
#			protocol => mandatory }
#	protocol - string, see Protocol in firewalld.richlanguage(5)
#	icmp_block - string, see ICMP-Block in firewalld.richlanguage(5)
#	masquerade - bool, see Masquerade in firewalld.richlanguage(5)
#	forward_port => { see Forward-Port in firewalld.richlanguage(5)
#		portid   => mandatory
#		protocol => mandatory
#		to_port  => mandatory to specify either to_port or/and to_addr
#		to_addr  => mandatory to specify either to_port or/and to_addr }
#	log => {   see Log in firewalld.richlanguage(5)
#		prefix => string, optional
#		level  => string, optional
#		limit  => string, optional }
#	audit => {  see Audit in firewalld.richlanguage(5)
#		limit => string, optional }
#	accept - any value, e.g. true, see Action in firewalld.richlanguage(5)
#	reject => { see Action in firewalld.richlanguage(5)
#		type => string, optional }
#	drop - any value, e.g. true, see Action in firewalld.richlanguage(5)
#
# === Examples
#
#  firewalld::zone { "custom":
#	description	=> "This is an example zone",
#	services	=> ["ssh", "dhcpv6-client"],
#	ports		=> [{
#			comment		=> "for our dummy service",
#			port		=> "1234",
#			protocol	=> "tcp",},],
#	masquerade	=> true,
#	forward_ports	=> [{
#			comment		=> 'forward 123 to other machine',
#			portid		=> '123',
#			protocol	=> 'tcp',
#			to_port		=> '321',
#			to_addr		=> '1.2.3.4',},],
#	rich_rules	=> [{
#			family		=> 'ipv4',
#			source		=> {
#				address		=> '192.168.1.0/24',
#				invert		=> true,},
#			port		=> {
#				portid		=> '123-321',
#				protocol	=> 'udp',},
#			log		=> {
#				prefix		=> 'local',
#				level		=> 'notice',
#				limit		=> '3/s',},
#			audit		=> {
#				limit		=> '2/h',},
#			reject		=> {
#				type		=> 'icmp-host-prohibited',},
#			},],}
#
