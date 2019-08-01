#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && cd .. && pwd )"
cd ${SCRIPT_DIR}

source definitions.sh

export AWS_ACCESS_KEY_ID="${S3_ACCESS_KEY}"
export AWS_SECRET_ACCESS_KEY="${S3_SECRET_KEY}"

./venv/bin/aws --endpoint-url ${S3_ENDPOINT} s3 sync $1 $2