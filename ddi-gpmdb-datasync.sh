#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "${SCRIPT_DIR}" || exit
source definitions.sh


MEMORY_LIMIT=2000
JOB_NAME="ddi-gpmdb-datasync"

bsub -M ${MEMORY_LIMIT} -R "rusage[mem=${MEMORY_LIMIT}]" -q ${QUEUE} -u ${JOB_EMAIL} -J ${JOB_NAME} \
    ./command.sh -o "logs/$JOB_NAME.$(date +"%m-%d-%Y").log" \
    "./sync.sh ${GPMDB_DATA_FOLDER} s3://${S3_BUCKET}/data/gpmdb"
