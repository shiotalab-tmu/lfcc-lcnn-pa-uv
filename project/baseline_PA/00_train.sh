#!/bin/bash
########################
# Script for evaluation
# Usage:
#   1. please check that config.py has been properly configured
#   2. $: bash 00_train.sh > /dev/null 2>&1 &
#   3. please check log_train and log_err to monitor the training
#      process
#
# Note:
#   1. The script by default uses the pre-trained model from ASVspoof2019
#      If you don't want to use it, just delete the option --trained-model
#   2. For options, check $: python main.py --help
########################

result_dir=results/$(date +%Y%m%d-%H%M%S)
if [ -d "${result_dir}" ]; then
  echo "ディレクトリ ${result_dir} は既に存在します。もう一度実行してください。"
  exit 1
fi
mkdir -p ${result_dir}/checkpoint

log_train_name=${result_dir}/log_train
log_err_name=${result_dir}/log_err
pretrained_model=__pretrained/trained_network.pt

echo -e "Training"
echo -e "Please monitor the log training: $PWD/${log_train_name}.txt\n"
source $PWD/../../env.sh
python main.py --model-forward-with-file-name \
       --num-workers 3 --epochs 100 \
       --no-best-epochs 50 --batch-size 64 \
       --sampler block_shuffle_by_length \
       --lr-decay-factor 0.5 --lr-scheduler-type 1 \
       --trained-model ${pretrained_model} \
       --ignore-training-history-in-trained-model \
       --save-model-dir ${result_dir}/checkpoint \
       --lr 0.0003 --seed 1000 > ${log_train_name}.txt 2>${log_err_name}.txt
echo -e "Training process finished"
echo -e "Training log has been written to $PWD/${log_train_name}.txt"





