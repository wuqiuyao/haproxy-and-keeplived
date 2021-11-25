{% if grains['osmajorrelease'] == 8 %}
ncurses-compat-libs:
  pkg.installed
{% endif %}

{% if grains['osmajorrelease'] == 7 %}
libaio-devel:
  pkg.installed
{% endif %}

create-mysql-user:
  user.present:
    - name: mysql
    - createhome: false
    - system: true
    - shell: /sbin/nologin

{{ pillar['mysql_datadir'] }}:
  file.directory:
    - user: mysql
    - group: mysql
    - mode: '0755'
    - makedirs: true

/etc/my.cnf.d/:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true

mysql-unzip:
  archive.extracted:
    - name: /usr/src
    - source: salt://modules/database/mysql/files/mysql-5.7.34-linux-glibc2.12-x86_64.tar.gz
    - if_missing: /usr/src/mysql-5.7.34-linux-glibc2.12-x86_64

mysql-install:
  cmd.script:
    - name: salt://modules/database/mysql/files/install.sh.j2
    - template: jinja
    - unless: test -d {{ pillar['mysql_installdir'] }}

trasfer-files:
  file.managed:
    - names:
      - /etc/my.cnf:
        - source: salt://modules/database/mysql/files/my.cnf.j2
        - template: jinja
      - {{ pillar['mysql_installdir'] }}/support-files/mysql.server:
        - source: salt://modules/database/mysql/files/mysql.server.j2
        - template: jinja
      - /usr/lib/systemd/system/mysqld.service:
        - source: salt://modules/database/mysql/files/mysqld.service.j2
        - template: jinja
    - require:
      - cmd: mysql-install

mysqld-service:
  service.running:
    - name: mysqld
    - enable: true
    - reload: true
    - require:
      - mysql-install
    - watch:
      - file: trasfer-files
