#!/bin/bash
# Generate the report using the latest published.csv file

set -e # everything must pass
set -u # no unbound variables
set -xv  # output the scripts and interpolated steps

cd /opt/elife-reporting/

# purge any old reports, any old published.csv files
echo "cleaning up old files ..."
rm -f published.csv paper_history*

# download the latest published.csv file
# UPDATE 2017-05-16, a few notes:
# * I'm dubious the published.csv file was ever being fully downloaded given harakiri and nginx timeouts
# * The report was eventually hugely inefficient as the data model changed
# * The report has been re-implemented here: https://observer.elifesciences.org/report/published-research-article-index
# * Which is beside the point because lax doesn't actually need published.csv to do it's work.
#echo "downloading published.csv from Lax ..."
#wget -c https://lax.elifesciences.org/reports/published.csv -O published.csv --quiet

# generate the report without prompts
echo "generating report ..."
NOCONFIRM=1 bash /opt/elife-reporting/GetData.sh &> /tmp/cronjob-$(date -I).log
