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
    - If you want to evaluate the finetuned model:
        ```
        ./scripts/eval_official_finetuned_libero_spatial.sh
        ```
        
        That's all! You can see the evaluation loop running, and rollout videos will be saved for each episode.
    - If you want to evaluate the baseline model:
        ```
        ./scripts/eval_baseline_libero_spatial.sh
        ``` 
        You will encounter this error:
        ```
        AssertionError: Action un-norm key libero_spatial not found in VLA `norm_stats`!
        ```
        The root cause is the baseline OpenVLA model was trained on Open-X Embodiment datasets (Bridge, RT-1, etc.) but **NOT on LIBERO data**. Therefore:
        - ✅ Model has norm_stats for: `bridge_orig`, `fractal20220817_data`, `kuka`, etc.
        - ❌ Model does **NOT** have norm_stats for: `libero_spatial`, `libero_object`, `libero_goal`, etc.
        Two solutions:
        1. The correct way is to finetune the baseline model with Libero-Spatial, then use the finetuned model to eval
        2. If you want to **forcefully evaluate** a baseline model (for debugging, baseline comparison, etc.), you can override the normalization key. **This will result in poor performance** but allows the script to run. A reference code changes at [mod/run_libero_eval.py](mod/run_libero_eval.py)
    

---

## Finetune with Lora
1. Download Libero-Spatial finetune dataset: https://huggingface.co/datasets/openvla/modified_libero_rlds/tree/main/libero_spatial_no_noops
2. Launch and Attach into Docker Container
    Use headless since GUI no needed for finetuning.
    ```
    PRETRAINED_CHECKPOINT_ROOT=/home/xx/Documents/repos/hf_checkpoint \
    OPENVLA_REPO=/home/xx/Documents/repos/openvla \
    FINETUNE_DATASET_DIR=/home/xx/Documents/repos/hf_dataset \
    ./start_headless.sh
    ```
3. Run the finetune script
    ```
    ./scripts/finetune_with_lora.sh
    ```
    Mod the batch_size and LR by your GPU setting. The current setting can get a non-zero but not good performance on Libera-Spatial which is enough for learning-purpose only.
4. Run the evaluation script
    ```
    ./scripts/eval_our_finetuned_libero_spatial.sh
    ```