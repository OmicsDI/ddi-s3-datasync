#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd ${SCRIPT_DIR}
source definitions.sh

MEMORY_LIMIT=3000
JOB_EMAIL="gdass@ebi.ac.uk"
JOB_NAME="ddi-arrayexpress-datasync"

bsub -M ${MEMORY_LIMIT} -R "rusage[mem=${MEMORY_LIMIT}]" -q ${QUEUE} -u ${JOB_EMAIL} -J ${JOB_NAME}-experiments \
    ./command.sh logs/${JOB_NAME}-experiments.$(date +"%m-%d-%Y").log \
    "./venv/bin/python arrayexpress-splitter/experiments.py ${AE_EXPERIMENTS_FILE} ${AE_EXPERIMENTS_OUT_DIR}" \
    "./sync.sh ${AE_EXPERIMENTS_OUT_DIR} s3://${S3_BUCKET}/data/arrayexpress/experiments"

bsub -M ${MEMORY_LIMIT} -R "rusage[mem=${MEMORY_LIMIT}]" -q ${QUEUE} -u ${JOB_EMAIL} -J ${JOB_NAME}-protocols \
    ./command.sh logs/${JOB_NAME}-protocols.$(date +"%m-%d-%Y").log \
    "./venv/bin/python arrayexpress-splitter/experiments.py ${ARRAYEXPRESS_PROTOCOLS_FILE} ${AE_PROTOCOLS_OUT_DIR}"
    "./sync.sh ${AE_PROTOCOLS_OUT_DIR} s3://${S3_BUCKET}/data/arrayexpress/protocols"
