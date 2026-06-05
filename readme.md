# Jetson Orin Nano Edge AI CLI Assistant

This repository contains the architecture, automation scripts, and client utilities to deploy a hardware-accelerated, fine-tuned LLM microservice natively on an NVIDIA Jetson Orin Nano. 

Using `llama.cpp` compiled with CUDA support, the system exposes an OpenAI-compatible REST API over a local Mac-to-Jetson USB-C network link, serving token inference at optimized speeds.

## System Architecture

* **Model:** Fine-tuned TinyLlama (1.1B parameters, 4-bit GGUF quantization)
* **Edge Hardware:** NVIDIA Jetson Orin Nano (Ampere Architecture, Unified Memory)
* **Host Machine:** macOS / Linux Client
* **Interconnect:** Virtual Ethernet over USB-C data link (`192.168.55.1`)
* **Inference Engine:** `llama.cpp` (CUDA-accelerated)

---

## Repository Structure

```text
jetson-edge-cli-assistant/
├── .gitignore                  # Prevents tracking large model weights and build files
├── README.md                   # Comprehensive documentation and guide
├── notebooks/
│   └── tinyllama_finetuning.ipynb # Training notebook for the command-line dataset
├── scripts/
│   ├── setup_jetson.sh         # Automates native compilation with CUDA on edge hardware
│   └── start_server.sh         # Disables display manager to reclaim RAM and starts API
└── client/
    ├── test_api.py             # Python client utility to query the microservice
    └── test_api.sh             # Lightweight cURL/Bash verification script
```

---

## Deployment Guide

### Phase 1: Preparation (On the Host Machine)
Because the Jetson operates on a private network via the USB-C link, download the inference engine source code on your internet-connected host machine first.

1. Clone this repository onto your host laptop.
2. Download the dependencies and bundle them:
   ```bash
   git clone [https://github.com/ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp)
   tar -czvf llama_cpp.tar.gz llama.cpp/
   ```
3. Transfer the bundled engine and your fine-tuned `.gguf` model file over the USB-C link to the Jetson:
   ```bash
   scp llama_cpp.tar.gz sjsujetson@192.168.55.1:~/
   scp path/to/your/tinyllama-linux-cli-Q4_K_M.gguf sjsujetson@192.168.55.1:~/
   ```

### Phase 2: Compilation & Execution (On the Jetson)
1. SSH into your Jetson Orin Nano:
   ```bash
   ssh sjsujetson@192.168.55.1
   ```
2. Run the automated environment setup script. This script will extract your source code bundle and compile `llama.cpp` natively with full CUDA hardware acceleration enabled:
   ```bash
   chmod +x scripts/setup_jetson.sh
   ./scripts/setup_jetson.sh
   ```
3. Launch the hardware-optimized microservice. This automatically handles turning off the Ubuntu Display Manager (`gdm3`) to recover ~1GB of VRAM for inference:
   ```bash
   chmod +x scripts/start_server.sh
   ./scripts/start_server.sh
   ```

### Phase 3: Testing the API (From the Host Machine)
Open a separate terminal tab or window on your host machine and navigate to the project directory.

* **Option A: Python Client**
  Install requirements and run the tester script:
  ```bash
  pip install requests
  python client/test_api.py
  ```

* **Option B: Bash Client**
  Execute the rapid shell execution script:
  ```bash
  chmod +x client/test_api.sh
  ./client/test_api.sh
  ```

---

## API Performance Benchmarks (Orin Nano)
* **Prompt Processing (Prefill):** ~280+ tokens/sec (Fully offloaded to Ampere GPU)
* **Token Generation (Decoding):** ~50+ tokens/sec

### Verification

Here is the microservice initializing and exposing the API endpoint natively on the Jetson Orin Nano:

![Jetson Server Initialization](images/server_logs.jpg)

And the corresponding low-latency JSON response received on the host Mac:

![Host Mac Client Request](images/api_response.jpg)