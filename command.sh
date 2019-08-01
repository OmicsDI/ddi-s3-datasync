#!/usr/bin/env bash

COMMANDS=()
while [[ $# -gt 0 ]]
do
KEY="$1"

case ${KEY} in
    -o|--output)
    OUTPUT="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    COMMANDS+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

FINAL_COMMAND="{"

for (( i = 0; i < ${#COMMANDS[@]} ; i++ )); do
    if [[ ${i} -eq 0 ]]; then
        `${COMMANDS[$i]} > ${OUTPUT} 2>&1`
    else
        `${COMMANDS[$i]} >> ${OUTPUT} 2>&1`
    fi
done
