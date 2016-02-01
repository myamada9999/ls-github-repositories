#!/bin/bash

GITHUB_API="https://api.github.com/users/"
WORKDIR=`mktemp -d`

function abort
{
	echo "ERROR: $@" 1>&2
	exit 1
}

function usage
{
    echo "Usage: $0 USER"
    exit 1
}

# Get USER name
USER=$1
[ -z $USER ] && usage

# Check curl, parsrj command
[ ! `which curl` ] && abort "curl command not found."
[ ! -f parsrj.sh ] && abort "parsrj.sh not found."

# Check status. If it is 200 OK, go next.
STATUS=`curl -I $GITHUB_API$USER"/repos?per_page=100" 2> /dev/null | grep "Status:"`
CHECK=`echo $STATUS | grep "200 OK"`
[ -z "${CHECK}" ] && abort $GITHUB_API$USER": "$STATUS

# Get the last page number.
# If LAST_PAGE is not found, the user has only 1 page.
LAST_PAGE=`curl -I $GITHUB_API$USER"/repos?per_page=100" 2> /dev/null \
			| grep "rel=\"last\"" | cut -d";" -f2 | cut -d"=" -f4 | cut -d">" -f1`
[ -z $LAST_PAGE ] && LAST_PAGE="1"
LAST_PAGE=`expr $LAST_PAGE + 1`

# Get full_name of all repositories.
for ((i=1; i<$LAST_PAGE; i++));
do
	curl $GITHUB_API$USER"/repos?page="$i"&per_page=100" > ${WORKDIR}/.tmp 2> /dev/null
	./parsrj.sh ${WORKDIR}/.tmp | grep "\.full_name" | cut -d " " -f2
done

[ -d ${WORKDIR} ] && rm -rf ${WORKDIR}

exit 0
