#!/bin/bash
# scripts/start_server.sh

MODEL_PATH="$HOME/tinyllama-linux-cli-Q4_K_M.gguf"
PORT=8080
HOST="192.168.55.1"

if [ ! -f "$MODEL_PATH" ]; then
    echo "Error: Model file not found at $MODEL_PATH"
    echo "Please transfer your fine-tuned .gguf file to your home directory first."
    exit 1
fi

echo "Optimizing Jetson memory by stopping display manager..."
sudo systemctl stop gdm3

echo "Starting hardware-accelerated LLM microservice on port $PORT..."
./llama.cpp/build/bin/llama-server \
  -m "$MODEL_PATH" \
  -c 512 \
  --host "$HOST" \
  --port "$PORT" \
  -ngl 99