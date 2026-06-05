#!/bin/bash
# scripts/setup_jetson.sh

echo "================================================"
echo " Starting Jetson Orin Nano Environment Setup... "
echo "================================================"

# Check if the transferred zip file exists
if [ -f "$HOME/llama_cpp.tar.gz" ]; then
    echo "[1/3] Unpacking llama.cpp source code..."
    tar -xzf "$HOME/llama_cpp.tar.gz" -C "$HOME/"
elif [ ! -d "$HOME/llama.cpp" ]; then
    echo "ERROR: llama_cpp.tar.gz not found in $HOME."
    echo "Please transfer it from your host machine first using SCP."
    exit 1
fi

# Navigate to the directory and compile
echo "[2/3] Configuring CMake for NVIDIA Ampere GPU..."
cd "$HOME/llama.cpp" || exit
mkdir -p build && cd build

cmake .. -DLLAMA_CUDA=ON

echo "[3/3] Compiling inference engine (This will take 5-10 minutes)..."
cmake --build . --config Release -j 4

echo "================================================"
echo " Setup Complete! You can now start the server.  "
echo "================================================"