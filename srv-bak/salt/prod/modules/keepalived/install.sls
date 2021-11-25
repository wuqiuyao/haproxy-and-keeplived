download-keepalived:
  pkg.installed:
    - name: keepalived

master-config-file:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://modules/keepalived/files/master_keepalived.conf.j2
    - template: jinja
