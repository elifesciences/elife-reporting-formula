#!/bin/bash
# 'publishing' the reports involves sanitizing their contents and moving them
# to the /srv/jg-reports/ directory where the web server does a file listing.

set -e # everything must succeed
cd /opt/elife-reporting/

# purge any previous sanitization attempt
echo "cleaning up any old sanitization files ..."
rm -rf ./sanitized 
mkdir ./sanitized

# sanitize 
for fname in `ls paper_history*.csv`; do
    echo "sanitizing $fname"
    ./sanitize.sh $fname
    if [ ! -f sanitized/$fname ]; then
        echo "FAILED to sanitize $fname"
        echo "no further files will be processed. nothing will be published"
        exit 1
    fi
done

# move all generated csv files to the webserver accessible dir
echo "publishing sanitized reports to /srv/jg-reports/"
mv ./sanitized/paper_history*.csv /srv/jg-reports/
rmdir ./sanitized
