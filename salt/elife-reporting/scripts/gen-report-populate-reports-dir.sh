#!/bin/bash
set -e
echo "===> the time is" `date`
. ./gen-reports.sh
if [ -d /srv/jg-reports/ ]; then
    # directory only exists within Vagrant
    . ./publish-reports.sh
fi
echo "===> done :)"
