#!/bin/bash
########################
# Script for evaluation
# Usage:
#   1. please check that config.py has been properly configured
#   2. please specify the trained model
#      here, we use a pre-trained model from ASVspoof2019
#   2. $: bash 01_eval.sh
########################

result_dir=results/$(date +%Y%m%d-%H%M%S)
if [ -d "${result_dir}" ]; then
  echo "ディレクトリ ${result_dir} は既に存在します。もう一度実行してください。"
  exit 1
fi
mkdir -p ${result_dir}

log_name=${result_dir}/log_eval
trained_model=__pretrained/trained_network.pt

echo -e "Run evaluation"
source $PWD/../../env.sh
python main.py --inference --model-forward-with-file-name \
       --trained-model ${trained_model}> ${log_name}.txt 2>${log_name}_err.txt
cat ${log_name}.txt | grep "Output," | awk '{print $2" "$4}' | sed 's:,::g' > ${log_name}_score.txt
echo -e "Process log has been written to $PWD/${log_name}.txt"
echo -e "Score has been written to $PWD/${log_name}_score.txt"
