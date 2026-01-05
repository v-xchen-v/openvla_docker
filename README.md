# Docker & Script to Reproduce OpenVLA

## Environment Setup
1. Build Docker Image
    ```
    ./build.sh
    ```
2. Clone/Download repos
- openvla
    ```
    mkdir -p /home/xx/Documents/repos
    # cd to the created folder
    git clone https://github.com/openvla/openvla.git
    ```
- checkpoints

    For example, download baseline model openvla/openvla-7b
    ```
    mkdir -p /home/xx/Documents/repos/hf_checkpoint
    # cd to the created folder
    git lfs install
    git clone https://huggingface.co/openvla/openvla-7b
    ```
3. Launch Container
    - used -v to mount the checkpoint folder and openvla repo folder to the container

    ```
    xhost +
    PRETRAINED_CHECKPOINT_ROOT=/home/xx/Documents/repos/hf_checkpoint \
    OPENVLA_REPO=/home/xx/Documents/repos/openvla \
    ./start_gui.sh
    ```
    That's all for OpenVLA environment setup!

---


## Run LIBERO Eval

1. Launch and Attach into Docker Container
    - Note that you should use the _gui start script since LIBERO (based on MUJOCO) evaluation requires DISPLAY
    ```
    xhost +
    PRETRAINED_CHECKPOINT_ROOT=/home/xx/Documents/repos/hf_checkpoint \
    OPENVLA_REPO=/home/xx/Documents/repos/openvla \
    ./start_gui.sh
    ```
2. Run the eval script

    Provided eval scripts for Libero-Spatial Task Suite:
    - If you want to evaluate the baseline model:
        ```
        ./scripts/eval_baseline_libero_spatial.sh
        ``` 
    - If you want to evaluate the finetuned model:
        ```
        ./scripts/eval_finetuned_libero_spatial.sh
        ```
    That's all! You can see the evaluation loop running, and rollout videos will be saved for each episode.
---

