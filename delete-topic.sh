#!/bin/bash

TOPIC_FILE="delete-topic-definition.yaml"

# Check for yq
command -v yq >/dev/null || { echo "yq is required to parse YAML"; exit 1; }

# Loop through topics
yq e '.topics[]' "$TOPIC_FILE" | yq -e '.topics[] | [.name ] | @tsv' "$TOPIC_FILE" | while IFS=$'\t' read -r NAME;
do
  echo "Delete topic: $NAME"
  /etc/confluent-7.9.0/bin/kafka-topics --delete --bootstrap-server localhost:9092 \
    --topic "$NAME"
done

