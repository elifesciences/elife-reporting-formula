#
# cron
#
# every weekday at 12:00pm UTC
generate-report: # daily
    cron.present:
        - user: {{ pillar.elife.deploy_user.username }}
        - identifier: generate-report
        - name: cd /opt/elife-reporting/ && /bin/bash gen-report-populate-reports-dir.sh
        - hour: 12
        - minute: 15
        - require:
            - cmd: configure-jg-tools
            - file: generate-report-scripts

