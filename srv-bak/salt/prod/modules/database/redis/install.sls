dep-redis-pkg-install:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - make
      - tcl-devel
      - systemd-devel

unzip-redis:
  archive.extracted:
    - name: /usr/src
    - source: salt://modules/database/redis/files/redis-{{ pillar['redis_version'] }}.tar.gz
    - if_missing: /usr/src/redis-{{ pillar['redis_version'] }}

redis-install:
  cmd.script:
    - name: salt://modules/database/redis/files/install.sh.j2
    - template: jinja
    - unless: test -d {{ pillar['redis_installdir'] }}
    - require:
      - archive: unzip-redis

{{ pillar['redis_installdir'] }}/conf:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makefirs: true
    - require:
      - redis-install

config-file:
  file.managed:
    - names:
      - /usr/lib/systemd/system/redis_server.service:
        - source: salt://modules/database/redis/files/redis_server.service.j2
        - template: jinja
      - {{ pillar['redis_installdir'] }}/conf/redis.conf:
        - source: salt://modules/database/redis/files/redis.conf.j2
        - template: jinja
        - require:
          - file: {{ pillar['redis_installdir'] }}/conf

redis_server.service:
  service.running:
    - enable: true
    - reload: true
    - require:
      - cmd: redis-install
    - watch:
      - file: {{ pillar['redis_installdir'] }}/conf/redis.conf
