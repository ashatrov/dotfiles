#!/bin/bash

################
##### JSON #####
################

function jsonValPython () # Print formatted JSON
{
	python -c "import json,sys;sys.stdout.write(json.dumps(json.load(sys.stdin)$1, sort_keys=True, indent=4))";
}

function jsonVal () # Print formatted JSON
{
	# Use echo '{"foo": {"bar": "baz", "a": [1,2,3]}}' |  getJsonValPHP "->foo->a['0']"
	php -r "\$json=json_decode(file_get_contents('php://stdin')); print_r(\$json$1);"
}

####################
##### END JSON #####
####################

##################
##### DOCKER #####
##################

function dockerRemoveAllContainers () # Remove all Docker containers
{
	docker ps -a
	if [[ "$(docker ps -a -q)" ]]; then
		docker stop $(docker ps -a -q)
		docker rm $(docker ps -a -q)
		docker ps -a
	fi
}

function dockerDeleteAllContainers () # (Aliace) Remove all Docker containers
{
    dockerRemoveAllContainers
}

function dockerRemoveAllImages () # Remove all Docker images
{
	dockerRemoveAllContainers
	docker rmi $(docker images -a -q)
}

function dockerDeleteAllImages () # (Aliace) Remove all Docker images
{
    dockerRemoveAllImages
}

######################
##### END DOCKER #####
######################

#########################
##### SERVICE FUNCS #####
#########################

function myhelp() # Show a list of functions
{
echo "
JSON
    jsonValPython - Print formatted JSON
    jsonVal       - Print formatted JSON

DOCKER
    dockerRemoveAllContainers - Remove all Docker containers (alias: dockerDeleteAllContainers)
    dockerRemoveAllImages     - Remove all Docker images (alias: dockerDeleteAllImages)
";
}

if [ "_$1" = "_" ]; then
    myhelp
else
    "$@"
fi

#########################
##### SERVICE FUNCS #####
#########################