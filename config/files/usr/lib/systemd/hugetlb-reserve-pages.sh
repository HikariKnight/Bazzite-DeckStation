#!/bin/bash
# Change the values in /etc/default/hugepages_numa to edit values here
source /etc/default/hugepages_numa
# NODE = numanode
# PAGES = how many 1GB pages to reserve

nodes_path=/sys/devices/system/node/
if [ ! -d ${nodes_path} ]; then
	echo "ERROR: ${nodes_path} does not exist"
	exit 1
fi

reserve_pages()
{
	echo "${1}" > "${nodes_path}/node${2}/hugepages/hugepages-1048576kB/nr_hugepages"
	mkdir /dev/hugepages1G
	mount -t hugetlbfs -o pagesize=1G hugetblfs /dev/hugepages1G
}

reserve_pages "${PAGES}" "${NODE}"

