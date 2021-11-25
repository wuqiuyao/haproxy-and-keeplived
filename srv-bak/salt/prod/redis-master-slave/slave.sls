include:
  - modules.database.redis.install

slave-trasfer-files:
  file.managed:
  - names:
    - {{ pillar['redis_installdir'] }}/conf/redis.conf:
      - source: salt://redis-master-slave/files/redis.conf.j2
      - template: jinja

'systemctl restart redis_server':
  cmd.run
