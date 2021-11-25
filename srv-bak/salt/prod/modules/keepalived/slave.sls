include:
  - modules.keepalived.install

/etc/keepalived/keepalived.conf:
  file.managed:
    - source: salt://modules/keepalived/files/slave_keepalived.conf.j2

slave-keepalived.service:
  service.running:
    - name: keepalived.service
    - enable: true
    - reload: true
    - require:
      - pkg: download-keepalived
    - watch:
      - file: /etc/keepalived/keepalived.conf

