/etc/my.cnf.d/master.cnf:
  file.managed:
    - source: salt://modules/database/mysql/files/master.conf
    - user: root
    - group: root
    - mode: '0664'

master-stop-mysql:
  service.dead:
    - name: mysqld.service

master-start-mysql:
  service.running:
    - name: mysqld.servicee
