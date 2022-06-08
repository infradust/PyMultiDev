#!/bin/bash

paths=$(ls -d /repos/*/)
echo "${paths}"
repos="${paths//[$'/']repos[$'/']/}"
repos="${repos//[$'\t\r\n']/}"
repos="${repos//[$'/']/ }"

echo "updating development installed packages: ${repos}"
cmd="pip install --no-deps --upgrade -e ${paths}"
eval "${cmd}" > /dev/null

python "/repos/${1}/setup.py" test
rm -rf "/repos/${1}/.eggs" "/repos/${1}/*.egg-info"

