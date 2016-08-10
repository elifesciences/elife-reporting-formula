#!/bin/bash
# takes a generated report and drops some potentially sensitive fields
# output is placed in a subdirectory called 'sanitized'

set -e # everything must pass
set -u # no unbound variables
set -xv  # output the scripts and interpolated steps

report=$1

cd /opt/elife-reporting/

if [ ! -e $report ]; then
    echo "first argument must be the filename of the report to sanitize"
    exit 1
fi

# create a directory that will hold our sanitized reports (if it doesn't exist)
mkdir -p ./sanitized

# parse out the columns that can't be made public
csvcut -C country,senior_editor,reviewing_editor $report > ./sanitized/$report
