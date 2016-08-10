#!/bin/bash
# Generate the report using the latest published.csv file

set -e # everything must succeed
cd /opt/elife-reporting/

# purge any old reports, any old published.csv files
echo "cleaning up old files ..."
rm -f published.csv paper_history*
# download the latest published.csv file
# TODO: update path to report once we have something less ad-hoc and in production
echo "downloading published.csv from Lax ..."
wget -c https://lax.elifesciences.org/reports/published.csv -O published.csv --quiet
# generate the report without prompts
echo "generating report ..."
NOCONFIRM=1 bash /opt/elife-reporting/GetData.sh &> /tmp/cronjob-$(date -I).log
