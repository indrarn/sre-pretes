#!/bin/bash

read -p "Input path folder log: " userInput
logDir="${userInput:-.}"
executedAt=$(date +"%Y-%m-%dT%H:%M:%S.000")

echo "Executed at $executedAt"
echo ""

for logFile in "$logDir"/*.log; do
    count=0

    for i in $(seq 10 -1 0); do
        minutes=$(date -u -d "$i minutes ago" +"%d/%b/%Y:%H:%M")
        matches=$(grep "$minutes" "$logFile" | grep -c " 500 ")
        count=$(( count + matches ))
    done

    basename=$(basename "$logFile")
    echo "There were $count HTTP 500 errors in ./$basename in the last 10 minutes."
    
done
