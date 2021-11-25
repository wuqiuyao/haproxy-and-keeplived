"Development Tools":
  pkg.group_installed

include:
  - modules.web.nginx.install

{{ pillar['nginx_installdir'] }}/html/index.php:
  file.managed:
    - source: salt://modules/application/php/files/index.php
    - user: nginx
    - group: nginx
    - mode: '0644'
    - require:
      - cmd: nginx-installsh

{{ pillar['nginx_installdir'] }}/conf/nginx.conf:
  file.managed:
    - source: salt://lnmp/files/nginx.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require:
      - cmd: nginx-installsh

lnmp-nginx-service:
  service.running:
    - name: nginx
    - enable: true
    - reload: true
    - watch:
      - file: {{ pillar['nginx_installdir'] }}/conf/nginx.conf
    - require:
      - cmd: nginx-installsh
      - file: {{ pillar['nginx_installdir'] }}/conf/nginx.conf
