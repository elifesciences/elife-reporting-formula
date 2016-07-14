#!/bin/bash
set -e
cd /opt/elife-reporting/
report=$1

if [ ! -f $report ]; then
    echo "first argument must be the filename of the report to sanitize"
    exit 1
fi

# create a directory that will hold our sanitized reports (if it doesn't exist)
mkdir -p ./sanitized

# parse out the columns that can't be made public
csvcut -C country,senior_editor,reviewing_editor $report > ./sanitized/$report
