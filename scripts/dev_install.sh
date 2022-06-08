#!/bin/bash

mkdir -p /build
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
${script_dir}/collect_pydeps /build
paths=$(ls -d /repos/*/)
repos="${paths//[$'/']repos[$'/']/}"
repos="${repos//[$'\t\r\n']/}"
repos="${repos//[$'/']/ }"

use_deprecated=""
if [ "$1" == "YES" ]; then
  echo "USING LEGACY RESOLVER"
  use_deprecated="--use-deprecated=legacy-resolver"
fi

install_spark="$2"

req_file="/build/requirements.txt"
pip install -U ${use_deprecated} -r ${req_file} --find-links file:///pip_override
if [ "$?" != "0" ]; then
    echo "REQUIREMENTS INSTALL FAILED!"
    exit 1
fi 

#install in development mode
for d in ${repos}
do
    repo_dir="/repos/${d}"
    cd "${repo_dir}" || exit 1
    if [ -f "setup.py" ]; then
        pip install --no-deps -e .
        if [ "$?" != "0" ]; then
            >&2 echo "ERROR: setup.py failed for '${d}'"
            exit 1
        fi
    fi
    cd /
done

if [ "${install_spark}" == "YES" ]; then
  echo "installing spark"
  /scripts/spark_install.sh
fi
