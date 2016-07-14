#!/bin/bash
set -e
echo "===> the time is" `date`
source gen-reports.sh
source publish-reports.sh
echo "===> done :)"
