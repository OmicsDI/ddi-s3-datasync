#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd ${SCRIPT_DIR}
source definitions.sh


MEMORY_LIMIT=3000
JOB_EMAIL="gdass@ebi.ac.uk"
JOB_NAME="ddi-pride-datasync"

bsub -M ${MEMORY_LIMIT} -R "rusage[mem=${MEMORY_LIMIT}]" -q ${QUEUE} -u ${JOB_EMAIL} -J ${JOB_NAME} \
    ./command.sh -o "logs/$JOB_NAME.$(date +"%m-%d-%Y").log" \
    "./sync.sh ${PRIDE_DATA_FOLDER} s3://${S3_BUCKET}/data/pride"
