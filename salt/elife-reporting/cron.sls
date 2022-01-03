#
# cron
#

# every day at 12:15pm UTC, generate a report from EJP database exports.
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

# every day at 12:45pm UTC, remove reports older than a week.
# lsh@2022-01-03: datestamped reports replaced a single report to help diagnose when data problems occured for Paul Kelly.
# this was helpful several times some years ago but hasn't been used since. A 7 day window is arbitrary.
prune-generated-reports: # daily
    cron.present:
        - user: {{ pillar.elife.deploy_user.username }}
        - identifier: prune-generated-reports
        - name: cd /opt/elife-reporting/ && find -name 'paper_history*' -mtime +7
        - hour: 12
        - minute: 45
