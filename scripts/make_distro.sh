#!/bin/bash
unset VERSION_OVERRIDE

DEF_DEST_DIR="/dist"

dest_dir="${DEF_DEST_DIR}"
format=""

declare -A DIST_ARGS
declare -A SKIP

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    --help)
    echo "Usage: ./make_distro.sh (options)"
    echo "Will open a browser and use the ssh tunnel to connect to the jupyter notebook"
    echo "Options:"
    echo "-d|--dest-dir  : distribution files destination directory (default: ${DEF_DEST_DIR})"
    echo "-f|--format    : distribution output format (optional)"
    echo "--opt-<distro> : build parameters for <distro> (optional)"
    echo "--skip-<distro>: skip the building of a specific distro (optional)"
    exit 0
    ;;
    -d|--dest-dir)
    dest_dir="$2"; shift; shift;
    ;;
    -f|--format)
    format="$2"; shift; shift;
    ;;
    --skip-*)
    key=${key#--skip-}
    SKIP["${key}"]="skip"; shift;
    ;;
    --opt-*)
    key=${key#--opt-}
    DIST_ARGS["${key}"]="$2"; shift; shift;
    ;;
    *)    # unknown option
    POSITIONAL+=("$1"); shift; # save it in an array for later
    ;;
esac
done

if [ "${format}" != "" ]; then
    format="--format=${format}"
fi

mkdir -p ${dest_dir}
ddir="${dest_dir}"

dest_dir="--dist-dir ${dest_dir}"

paths=$(ls -d /repos/*/)
repos="${paths//[$'/']repos[$'/']/}"
repos="${repos//[$'\t\r\n']/}"
repos="${repos//[$'/']/ }"

cd /repos || exit 1

for d in ${repos}
do
    skip=${SKIP["${d}"]}
    if [ "${skip}" == "" ]; then
        if [ -f "${d}/setup.py" ]; then
            dist_args=${DIST_ARGS["${d}"]}
            name=$(python "${d}/setup.py" --name)
            name_fix="${name//-/_}"
            CMD="python ${d}/setup.py sdist ${dest_dir} ${format} ${dist_args}"
            echo "RUNNING: ${CMD}"
            eval "$CMD"
            rm -rf "${d}/${name_fix}.egg-info"
        fi
    fi
done
find "${ddir}" -name "*.tar.gz" -exec chmod +x {} \;
