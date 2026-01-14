cd $OPENVLA_REPO
export MUJOCO_GL=glx
python experiments/robot/libero/run_libero_eval.py \
  --model_family openvla \
  --pretrained_checkpoint $OPENVLA_REPO/experiments/finetune_libero_spatial/openvla-7b+libero_spatial_no_noops+b4+lr-0.0001+lora-r32+dropout-0.0 \
  --task_suite_name libero_spatial \
  --center_crop True