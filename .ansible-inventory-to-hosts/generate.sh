#!/bin/sh
FILENAME=
PDIR="$(cd "$(dirname "$0")" && pwd -P)"
DIR="$PDIR/$(dirname "$(readlink "$0")")"

usage()
{
    echo "usage: genereate-hosts [[[-f file ] | [-h]]"
}

while [ "$1" != "" ]; do
    case $1 in
        -f | --file )           shift
                                FILENAME=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [ ! -f "$FILENAME" ]; then
    echo "$FILENAME does not exist"
    exit 1
fi

# copy file to skip groups_vars and host_vars which may trigger ansible-vault
cp $FILENAME $DIR/hosts

# generate entries in /etc/hosts
ansible-playbook $DIR/playbook.yaml -i $DIR/hosts --ask-become-pass

