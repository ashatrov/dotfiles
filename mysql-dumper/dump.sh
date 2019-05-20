#!/bin/bash
# Requirements: mydumper (https://github.com/maxbube/mydumper)

## SETTINGS
# dump source
MYDUMPER_REMOTE_USER="root"
MYDUMPER_REMOTE_PASSWORD="root"
MYDUMPER_REMOTE_HOST="mysql.source.ru"

# dump target
MYDUMPER_LOCAL_USER="root"
MYDUMPER_LOCAL_PASSWORD="root"
MYDUMPER_LOCAL_HOST="127.0.0.1"

# mapping to be able to import to databases with different names. E.g. following this mapping `source_database_name_1` will be imported to `target_database_name_1`
MYDUMPER_REMOTE_DATABASES_MAP=(source_database_name_1 source_database_name_2)
MYDUMPER_LOCAL_DATAMASES_MAP=(target_database_name_1 target_database_name_2)

# Data dump won't be created for these tables, but schema will be created anyway
MYDUMPER_EXCEPT_TABLES=(table_name_to_skip_data_dump_1 table_name_to_skip_dump_2)

MYDUMPER_THREADS=4
## END: SETTINGS


if [[ -f $(dirname $0)/override_config.sh ]] ; then
    source $(dirname $0)/override_config.sh
fi

SCRIPT_DIR=$(dirname $0)

## QUESTION - Upload to the target mysql?
printf "\033[38;5;11m" ; read -p "Make a dump from remote server ${MYDUMPER_REMOTE_HOST} (N/y): " -r ; printf "\033[0m"
if [[ $REPLY =~ ^[Yy]$ ]]
then
	## EXPORT
    for REMOTE_DATABASE in ${MYDUMPER_REMOTE_DATABASES_MAP[@]} ; do
        echo -e "\n\n\n\n${REMOTE_DATABASE}\n\n"
        EXCEPT_REGEXP=$(printf "|${REMOTE_DATABASE}.%s$" "${MYDUMPER_EXCEPT_TABLES[@]}")
        EXCEPT_REGEXP="^(?!${EXCEPT_REGEXP:1})"
        EXPORT_DIR=${SCRIPT_DIR}/${REMOTE_DATABASE}-dump
        mydumper -m -v 3 -t ${MYDUMPER_THREADS} -s 500000 -C -e -o ${EXPORT_DIR} -h ${MYDUMPER_REMOTE_HOST} -u ${MYDUMPER_REMOTE_USER} -p ${MYDUMPER_REMOTE_PASSWORD} -P 3306 -B ${REMOTE_DATABASE} --regex ${EXCEPT_REGEXP}
        mydumper -d -G -E -R -v 3 -t ${MYDUMPER_THREADS} -C -e -o ${EXPORT_DIR} -h ${MYDUMPER_REMOTE_HOST} -u ${MYDUMPER_REMOTE_USER} -p ${MYDUMPER_REMOTE_PASSWORD} -P 3306 -B ${REMOTE_DATABASE}
    done;
    ## END: EXPORT
fi
## END: QUESTION - Upload to the target mysql?



## QUESTION - Upload to the target mysql?
printf "\033[38;5;11m" ; read -p "Upload dump to the target database ${MYDUMPER_LOCAL_HOST} (N/y): " -r ; printf "\033[0m"
if [[ $REPLY =~ ^[Yy]$ ]]
then
	## IMPORT
    i=0
    for REMOTE_DATABASE in ${MYDUMPER_REMOTE_DATABASES_MAP[@]}; do
        echo -e "\n\n\n\nIMPORT: ${REMOTE_DATABASE} -> ${MYDUMPER_LOCAL_DATAMASES_MAP[$i]}\n\n";
        EXPORT_DIR=${SCRIPT_DIR}/${REMOTE_DATABASE}-dump
        mysql -h ${MYDUMPER_LOCAL_HOST} -u ${MYDUMPER_LOCAL_USER} -p${MYDUMPER_LOCAL_PASSWORD} -e "DROP DATABASE IF EXISTS ${MYDUMPER_LOCAL_DATAMASES_MAP[$i]}; CREATE DATABASE ${MYDUMPER_LOCAL_DATAMASES_MAP[$i]} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;";
        myloader -d ${EXPORT_DIR} -o -t ${MYDUMPER_THREADS} -C -v 3 -B ${MYDUMPER_LOCAL_DATAMASES_MAP[$i]} -h ${MYDUMPER_LOCAL_HOST} -u ${MYDUMPER_LOCAL_USER} -p ${MYDUMPER_LOCAL_PASSWORD}
        ((i++));
    done;
    ## END: IMPORT
fi
## END: QUESTION - Upload to the target mysql?


