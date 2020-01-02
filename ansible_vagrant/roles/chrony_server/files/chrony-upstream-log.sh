#!/bin/bash

INPUT=$(chronyc sources)
OUTPUT_LOGS_FILE="/var/log/chrony-current-upstream.log"
REGEX="^\^\*"
CURRENT_TIMESTAMP=$(date "+%b %d %H:%M:%S %Y")

while IFS= read -r LINE
do
  TRIMMED_LINE=$(echo $LINE | xargs)
  if [[ $TRIMMED_LINE =~ $REGEX ]];
  then
    CURRENT_SYNCED_IP=$(echo "$TRIMMED_LINE" | cut -d ' ' -f 2)
    printf '%s\n' "$CURRENT_TIMESTAMP :: $CURRENT_SYNCED_IP" >> $OUTPUT_LOGS_FILE
  fi
done <<< "$INPUT"
