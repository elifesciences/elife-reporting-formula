jg-reports-web-config:
    file.managed:
        - name: /etc/nginx/sites-enabled/jg-reports.conf
        - source: salt://elife-reporting/config/etc-nginx-sites-enabled-jg-reports.conf
        - require:
            - file: reports-dir
        - watch_in:
            - service: nginx-server-service
