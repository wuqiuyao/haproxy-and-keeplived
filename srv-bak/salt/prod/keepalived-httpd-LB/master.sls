include:
  - modules.keepalived.master

master-download-httpd:
  pkg.installed:
    - name: httpd

master-create-scripts:
  file.directory:
    - name: /opt/scripts
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true

master-file-managed:
  file.managed:
    - names:
      - /usr/share/httpd/noindex/index.html:
        - source: salt://keepalived-httpd-LB/files/index.html
      - /opt/scripts/check_status.sh:
        - source: salt://keepalived-httpd-LB/files/check_status.sh
        - mode: '0755'
      - /etc/keepalived/keepalived.conf:
        - source: salt://keepalived-httpd-LB/files/master_keepalived.conf.j2
        - template: jinja  

master-service-httpd:
  service.running:
    - name: httpd
    - enable: true
    - reload: true

master-service-keepalived:
  service.running:
    - name: keepalived
    - restart: true
    - watch:
      - file: /etc/keepalived/keepalived.conf
