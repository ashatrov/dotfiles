#!/bin/bash

export REMOTE_USER="root"
export REMOTE_PASSWORD="root"
export REMOTE_HOST="mysql.source.ru"

export LOCAL_USER="root"
export LOCAL_PASSWORD="root"
export LOCAL_HOST="127.0.0.1"

export REMOTE_DATABASES_MAP=(source_database_name_1 source_database_name_2)
export LOCAL_DATAMASES_MAP=(target_database_name_1 target_database_name_2)

export EXCEPT_TABLES=(table_name_to_skip_data_dump_1 table_name_to_skip_dump_2)


## EXPORT
for REMOTE_DATABASE in ${REMOTE_DATABASES_MAP[@]} ; do
	echo -e "\n\n\n\n${REMOTE_DATABASE}\n\n"
	EXCEPT_REGEXP=$(printf "|${REMOTE_DATABASE}.%s$" "${EXCEPT_TABLES[@]}")
	EXCEPT_REGEXP="^(?!${EXCEPT_REGEXP:1})"
	mydumper -m -v 3 -t 4 -s 500000 -C -e -o ${REMOTE_DATABASE}-export -h ${REMOTE_HOST} -u ${REMOTE_USER} -p ${REMOTE_PASSWORD} -P 3306 -B ${REMOTE_DATABASE} --regex ${EXCEPT_REGEXP}
	mydumper -d -G -E -R -v 3 -t 4 -C -e -o ${REMOTE_DATABASE}-export -h ${REMOTE_HOST} -u ${REMOTE_USER} -p ${REMOTE_PASSWORD} -P 3306 -B ${REMOTE_DATABASE}
done;
## END: EXPORT


## Upload to local mysql?
read -p "Upload to local mysql? " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi
## END: Upload to local mysql?


## IMPORT
i=0
for REMOTE_DATABASE in ${REMOTE_DATABASES_MAP[@]}; do
 echo -e "\n\n\n\nIMPORT: ${REMOTE_DATABASE} -> ${LOCAL_DATAMASES_MAP[$i]}\n\n";
 mysql -h ${LOCAL_HOST} -u ${LOCAL_USER} -p${LOCAL_PASSWORD} -e "DROP DATABASE IF EXISTS ${LOCAL_DATAMASES_MAP[$i]}; CREATE DATABASE ${LOCAL_DATAMASES_MAP[$i]} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;";
 myloader -d ${REMOTE_DATABASE}-export -o -t 4 -C -v 3 -B ${LOCAL_DATAMASES_MAP[$i]} -h ${LOCAL_HOST} -u ${LOCAL_USER} -p ${LOCAL_PASSWORD}
 ((i++));
done;