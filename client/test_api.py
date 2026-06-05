# client/test_api.py
import requests
import json

JETSON_IP = "192.168.55.1"
PORT = "8080"
URL = f"http://{JETSON_IP}:{PORT}/v1/chat/completions"

payload = {
    "messages": [
        {
            "role": "user", 
            "content": "### Instruction:\nHow do I find a file named 'app.py'?\n\n### Response:\n"
        }
    ],
    "temperature": 0.2,
    "max_tokens": 100
}

print(f"Sending request to Jetson Orin Nano at {URL}...")
try:
    response = requests.post(URL, json=payload, timeout=10)
    if response.status_code == 200:
        result = response.json()
        answer = result['choices'][0]['message']['content']
        print("\n--- Jetson Response ---")
        print(answer.strip())
        print("-----------------------")
    else:
        print(f"Server returned error code: {response.status_code}")
except requests.exceptions.RequestException as e:
    print(f"Failed to connect to the Jetson microservice: {e}")
    print("Ensure the USB-C link is active and llama-server is running.")