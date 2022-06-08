#!/bin/bash

CLEAN="False"

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    --help)
    echo "usage: ./make_and_upload.sh [options]"
    echo "Options:"
    echo "--clean: clear all tar.gz file from dist folder"
    exit 0
    ;;
    --clean)
    CLEAN="True"
    shift
    ;;
esac
done

if [ "${CLEAN}" == "True" ]; then
    printf "deleting all existing distribution packages ..."
    sudo rm ./dist/*.tar.gz
    echo "done!"
fi

docker-compose run --rm maker
docker-compose run --rm uploader