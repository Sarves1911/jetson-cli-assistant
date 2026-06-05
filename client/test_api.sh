#!/bin/bash
# client/test_api.sh

JETSON_IP="192.168.55.1"
PORT="8080"
URL="http://$JETSON_IP:$PORT/v1/chat/completions"

echo "Sending hardware inference request to Jetson at $URL..."

curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {
        "role": "user",
        "content": "### Instruction:\nHow do I find a file named '\''app.py'\''?\n\n### Response:\n"
      }
    ],
    "temperature": 0.2,
    "max_tokens": 100
  }'
  
echo -e "\n\nRequest completed."