#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "${SCRIPT_DIR}" || exit

source definitions.sh

export AWS_ACCESS_KEY_ID="${S3_ACCESS_KEY}"
export AWS_SECRET_ACCESS_KEY="${S3_SECRET_KEY}"

echo "Starting to copy from $1 -> $2"

./venv/bin/aws --endpoint-url ${S3_ENDPOINT} --quiet s3 cp $1 $2

echo "Finished"