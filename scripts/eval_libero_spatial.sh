cd $OPENVLA_REPO
python experiments/robot/libero/run_libero_eval.py \
  --model_family openvla \
  --pretrained_checkpoint $PRETRAINED_CHECKPOINT_ROOT/openvla-7b-finetuned-libero-spatial \
  --task_suite_name libero_spatial \
  --center_crop True