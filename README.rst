===========
firewalld-formula
===========

Salt Stack Formula to set up and configure Firewalld, dynamically managed firewall with support for network/firewall zones to define the trust level of network connections or interfaces

NOTICE BEFORE YOU USE
=====================

* This formula aims to follow the conventions and recommendations described at http://docs.saltstack.com/topics/conventions/formulas.html

TODO
====

* configure local pre-commit hooks (code syntax check based on file extension, check for ugly *utf-8 mac os white space*)

Instructions
============

1. Add this repository as a `GitFS <http://docs.saltstack.com/topics/tutorials/gitfs.html>`_ backend in your Salt master config.

2. Configure your Pillar top file (``/srv/pillar/top.sls``), see pillar.example

3. Include this Formula within another Formula or simply define your needed states within the Salt top file (``/srv/salt/top.sls``).

Available states
================

.. contents::
    :local:

``firewalld``
-------
Manage firewalld

Additional resources
====================

None

Formula Dependencies
====================

None

Contributions
=============

Contributions are always welcome. All development guidelines you have to know are

* write clean code (proper YAML+Jinja syntax, no trailing whitespaces, no empty lines with whitespaces, LF only)
* set sane default settings
* test your code
* update README.rst doc

Salt Compatibility
==================

Tested with:

* 2014.1.x
* 2015.5.x

OS Compatibility
================

Tested with:

* CentOS 7
* Archlinux
