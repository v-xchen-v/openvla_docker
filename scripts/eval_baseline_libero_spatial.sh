cd $OPENVLA_REPO
export MUJOCO_GL=glx
python experiments/robot/libero/run_libero_eval.py \
  --model_family openvla \
  --pretrained_checkpoint $PRETRAINED_CHECKPOINT_ROOT/openvla-7b \
  --task_suite_name libero_spatial \
  --center_crop True