"Development Tools":
  pkg.group_installed

include:
  - modules.web.apache.install

/usr/include/httpd:
  file.symlink:
    - target: {{ pillar['httpd_installdir'] }}/include
    - require:
      - apache-install

{{ pillar['httpd_installdir'] }}/conf/extra/vhosts.conf:
  file.managed:
    - source: salt://lamp/files/vhosts.conf
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - apache-install

{{ pillar['httpd_installdir'] }}/htdocs/index.php:
  file.managed:
    - source: salt://modules/application/php/files/index.php
    - user: apache
    - group: apache
    - mode: '0644'
    - require:
      - apache-install

lamp-apache-service:
  service.running:
    - name: httpd
    - reload: true
    - enable: true
    - require:
      - apache-install
    - watch:
      - file: {{ pillar['httpd_installdir']}}/conf/httpd.conf
