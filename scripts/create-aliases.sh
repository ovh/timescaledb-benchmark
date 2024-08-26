#!/bin/bash
> .bash_aliases_bench
for file in ../ansible/inventories/{hosts,terraform} ; do
    echo "Parsing ${file}"
    for line in $(grep -vE "^(\[.*|#.*|)$" ${file} | sed 's/ ansible_ssh_host=/,/g' | sort | uniq); do
        name=$(echo ${line} | awk -F ',' '{ print $1 }')
        address=$(echo ${line} | awk -F ',' '{ print $2 }')
        echo "alias ${name}='ssh root@${address}'" >> .bash_aliases_bench
    done
done
