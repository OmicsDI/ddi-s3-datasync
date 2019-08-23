#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "${SCRIPT_DIR}" || exit
source definitions.sh

MEMORY_LIMIT=2000
JOB_NAME="ddi-expression-atlas-datasync"

bsub -M ${MEMORY_LIMIT} -R "rusage[mem=${MEMORY_LIMIT}]" -q ${QUEUE} -u ${JOB_EMAIL} -J "${JOB_NAME}-genes" \
    ./command.sh -o "logs/${JOB_NAME}-genes.$(date +"%m-%d-%Y").log" \
    "./venv/bin/python expression-atlas-splitter/expression_atlas.py ${EX_ATLAS_GENES} ${EX_ATLAS_GENES_OUTDIR}" \
    "./sync.sh ${EX_ATLAS_GENES_OUTDIR} s3://${S3_BUCKET}/data/expression-atlas/genes"

bsub -M ${MEMORY_LIMIT} -R "rusage[mem=${MEMORY_LIMIT}]" -q ${QUEUE} -u ${JOB_EMAIL} -J "${JOB_NAME}-experiments" \
    ./command.sh -o "logs/${JOB_NAME}-experiments.$(date +"%m-%d-%Y").log" \
    "./cp.sh ${EX_ATLAS_EXPERIMENTS} s3://${S3_BUCKET}/data/expression-atlas"

bsub -M ${MEMORY_LIMIT} -R "rusage[mem=${MEMORY_LIMIT}]" -q ${QUEUE} -u ${JOB_EMAIL} -J "${JOB_NAME}-relative-genes" \
    ./command.sh -o "logs/${JOB_NAME}-relative-genes.$(date +"%m-%d-%Y").log" \
    "./venv/bin/python expression-atlas-splitter/expression_atlas.py ${EX_ATLAS_RELATIVE_GENES} ${EX_ATLAS_RELATIVE_GENES_OUTDIR}" \
    "./sync.sh ${EX_ATLAS_RELATIVE_GENES_OUTDIR} s3://${S3_BUCKET}/data/expression-atlas/relative-genes"

bsub -M ${MEMORY_LIMIT} -R "rusage[mem=${MEMORY_LIMIT}]" -q ${QUEUE} -u ${JOB_EMAIL} -J "${JOB_NAME}-relative-experiments" \
    ./command.sh -o "logs/${JOB_NAME}-relative-experiments.$(date +"%m-%d-%Y").log" \
    "./cp.sh ${EX_ATLAS_RELATIVE_EXPERIMENTS} s3://${S3_BUCKET}/data/expression-atlas"