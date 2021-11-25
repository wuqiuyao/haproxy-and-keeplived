lnmp-dep-package:
  pkg.installed:
    - pkgs:
      - ncurses-devel 
      - openssl-devel
      - openssl
      - cmake
      - mariadb-devel
      - ncurses-compat-libs 

include:
  - modules.database.mysql.install

provides-mysql-file:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - names:
      - /etc/ld.so.conf.d/mysql.conf:
        - source: salt://lnmp/files/mysql.conf.j2
        - template: jinja     
 
/usr/local/include/mysql:
  file.symlink:
    - target: {{ pillar['mysql_installdir'] }}/mysql/include

set-password:
  cmd.run:
    - name: {{ pillar['mysql_installdir'] }}/bin/mysql -e "set password = password('{{ pillar['mysql_password'] }}');"
    - require:
      - service: mysqld-service
    - unless: {{ pillar['mysql_installdir'] }}/bin/mysql -uroot -p{{ pillar['mysql_password'] }} -e "exit"  
