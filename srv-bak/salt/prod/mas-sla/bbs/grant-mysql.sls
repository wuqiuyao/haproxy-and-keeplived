master-grant:
  cmd.run:
    - name: {{ pillar['mysql_installdir'] }}/bin/mysql -e "grant replication slave,super on *.* to 'repl'@'192.168.220.17' identified by 'repl';flush privileges;"

