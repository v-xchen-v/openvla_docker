cd $OPENVLA_REPO
LR=5e-5
BATCH_SIZE=4
torchrun --standalone --nnodes 1 --nproc-per-node 4 vla-scripts/finetune.py \
  --vla_path "openvla/openvla-7b" \
  --data_root_dir "/root/finetune_data/modified_libero_rlds" \
  --dataset_name libero_spatial_no_noops \
  --run_root_dir "/root/openvla/experiments/finetune_libero_spatial" \
  --adapter_tmp_dir "/root/openvla/experiments/finetune_libero_spatial/adapter_weights" \
  --lora_rank 32 \
  --batch_size $BATCH_SIZE \
  --grad_accumulation_steps 1 \
  --learning_rate $LR \
  --image_aug False \
  --wandb_project <YOUR_WANDB_PROJECT> \
  --wandb_entity <YOUR_WANDB_ENTITY> \
  --save_steps 5000