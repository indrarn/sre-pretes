#!/bin/bash

read -p "Masukkan path folder log: " userInput
logDir="${userInput:-.}"
executedAt=$(date +"%Y-%m-%dT%H:%M:%S.000")

echo "Executed at $executedAt"
echo ""

for logFile in "$logDir"/*.log; do
    lastTimestamp=$(tail -1 "$logFile" | awk '{print $4}' | tr -d '[')


    convertToIso=$(echo "$lastTimestamp" | awk -F'[/:]' '{
        months="JanFebMarAprMayJunJulAugSepOctNovDec"
        month_num = (index(months, $2) + 2) / 3
        printf "%04d-%02d-%02d %02d:%02d:%02d", $3, month_num, $1, $4, $5, $6
    }')

    cutoff=$(date -u -d "@$(( $(date -u -d "$normalized" +%s) - 600 ))" +"%d/%b/%Y:%H:%M")

    count=$(awk -v cutoff="$cutoff" '$4 > "[" cutoff && $9 == "500"' "$logFile" | wc -l)

    echo "There were $count HTTP 500 errors in ./$(basename "$logFile") in the last 10 minutes."
    
done
