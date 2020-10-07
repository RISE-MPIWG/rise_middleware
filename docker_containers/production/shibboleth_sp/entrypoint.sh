#!/bin/bash

SHIBBOLETH_ENTITY_ID="${SHIBBOLETH_ENTITY_ID}"
SHIBBOLETH_DISCOVERY_URL="${SHIBBOLETH_DISCOVERY_URL}"
SHIBBOLETH_METADATA_URL="${SHIBBOLETH_METADATA_URL}"
SHIBBOLETH_SKIP_DS_WITH_IDP="${SHIBBOLETH_SKIP_DS_WITH_IDP}"

rise_subst() {
    awk -v s="$1" -v r="$2" '{gsub(s, r)} 1' "$3" > /tmp/xxx
    mv /tmp/xxx "$3"
}

if [ -z "${SHIBBOLETH_ENTITY_ID}" ]
then
    echo "ERROR: Environment variable SHIBBOLETH_ENTITY_ID needs to be set! Aborting..."
    exit
else
    echo "Setting SP's entityID as ${SHIBBOLETH_ENTITY_ID}"
    rise_subst "@SHIBBOLETH_ENTITY_ID@" "${SHIBBOLETH_ENTITY_ID}" /etc/shibboleth/shibboleth2.xml
fi

if [ -z "${SHIBBOLETH_SKIP_DS_WITH_IDP}" ]
then
    echo "Not using direct IdP but WAYF/DS"
    rise_subst "@SHIBBOLETH_IDP_SKIPPING@" "" /etc/shibboleth/shibboleth2.xml
else
    echo "Setting IdP's entityID as ${SHIBBOLETH_SKIP_DS_WITH_IDP}"
    rise_subst "@SHIBBOLETH_IDP_SKIPPING@" "entityID=\"${SHIBBOLETH_SKIP_DS_WITH_IDP}\"" /etc/shibboleth/shibboleth2.xml
fi


if [ -z "${SHIBBOLETH_DISCOVERY_URL}" ]
then
    echo "ERROR: Environment variable SHIBBOLETH_DISCOVERY_URL needs to be set! Aborting..."
    exit
else
    echo "Setting Where-Are-You-From IdP Discovery as ${SHIBBOLETH_DISCOVERY_URL}"
    rise_subst "@SHIBBOLETH_DISCOVERY_URL@" "${SHIBBOLETH_DISCOVERY_URL}" /etc/shibboleth/shibboleth2.xml
fi

if [ -z "${SHIBBOLETH_METADATA_URL}" ]
then
    echo "ERROR: Environment variable SHIBBOLETH_METADATA_URL needs to be set! Aborting..."
    exit
else
    echo "Setting Metadata URL as ${SHIBBOLETH_METADATA_URL}"
    rise_subst "@SHIBBOLETH_METADATA_URL@" "${SHIBBOLETH_METADATA_URL}" /etc/shibboleth/shibboleth2.xml
fi

# Apache and Shibd gets grumpy about PID files pre-existing from previous runs
rm -f /etc/httpd/run/httpd.pid /var/lock/subsys/shibd

# Start Shibboleth SP
echo "Starting Shibboleth SP Daemon"
/etc/shibboleth/shibd-redhat start

# Start httpd
echo "Starting Apache 2 Daemon"
exec httpd -DFOREGROUND


