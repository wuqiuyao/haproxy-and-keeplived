include:
  - modules.keepalived.slave

slave-download-httpd:
  pkg.installed:
    - name: httpd

slave-create-scripts:
  file.directory:
    - name: /opt/scripts
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true

slave-file-managed:
  file.managed:
    - names:
      - /opt/scripts/notify.sh:
        - source: salt://keepalived-httpd-LB/files/notify.sh
        - mode: '0755'
      - /etc/keepalived/keepalived.conf:
        - source: salt://keepalived-httpd-LB/files/slave_keepalived.conf.j2        
        - template: jinja

slave-service-httpd:
  service.running:
    - name: httpd
    - enable: true
    - reload: true

slave-service-keepalived:
  service.running:
    - name: keepalived
    - restart: true
    - watch:
      - file: /etc/keepalived/keepalived.conf
