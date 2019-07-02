reporting-deps:
    pkg.installed:
        - pkgs:
            - sqlite3

s3bash-dep:
    archive.extracted:
        - user: root
        - group: root
        - name: /opt/s3-bash.0.02/
        - if_missing: /opt/s3-bash.0.02/
        - source: https://github.com/elifesciences/s3-bash/releases/download/0.02/s3-bash.0.02.tar.gz
        - archive_format: tar
        - source_hash: md5=3271b462ee96c5186de7747a557935e9
        - enforce_toplevel: false # we can guarantee this zip file is ok

    # needs a patch:
    # /opt/s3-bash.0.02/s3-common-functions
    # -declare -a temporaryFiles
    # +declare -a temporaryFiles=()

    file.patch:
        - name: /opt/s3-bash.0.02/s3-common-functions
        - source: salt://elife-reporting/patches/s3-common-functions.patch
        - hash: md5=cdad362deb7d54afe62c8b5acc02dda6
        - require:
            - archive: s3bash-dep

install-jg-tools:
    file.directory:
        - name: /opt/elife-reporting
        - owner: {{ pillar.elife.deploy_user.username }}
        - makedirs: True

    git.latest:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: https://github.com/elifesciences/eLife-Reporting-SQL
        - force_clone: true # lax may install some helper scripts before this clone, when the two are bundled
        - target: /opt/elife-reporting
        - require:
            - file: install-jg-tools
            - pkg: reporting-deps

configure-jg-tools:
    file.managed:
        - name: /opt/elife-reporting/config.cfg
        - source: salt://elife-reporting/config/opt-elife-reporting-config.cfg
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - template: jinja
        - require:
            - git: install-jg-tools

    cmd.run:
        - cwd: /opt/elife-reporting
        - user: {{ pillar.elife.deploy_user.username }}
        - name: source CreateDatabase.sh && mkdir -p output
        - require:
            - git: install-jg-tools
        - unless:
            - test -f /opt/elife-reporting/elife_paper_stats.sqlite

configure-s3-bash-credentials:
    file.managed:
        - name: /opt/elife-reporting/aws-secret-key
        - contents: {{ pillar.elife_reporting.aws.aws_secret }}
        - contents_newline: False

generate-report-scripts:
    file.recurse:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: /opt/elife-reporting/
        - source: salt://elife-reporting/scripts/
        - file_mode: 544 # readable to all, executable by elife

#
# cron
#

rotate-reports-and-logs:
    file.managed:
        - name: /etc/logrotate.d/elife-reporting
        - source: salt://elife-reporting/config/etc-logrotate.d-elife-reporting

