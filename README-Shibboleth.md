# Shibboleth Service Provider Configuration

The following variables for the  Service Provider (SP, see example values for staging) need to go to the .env file:

* SHIBBOLETH_ENTITY_ID=https://staging.rise.mpiwg-berlin.mpg.de/shibboleth
This is the unique ID of this Shibboleth SP instance. The SP is known by Identity Providers (IdPs) in the SAML federation under this name

* SHIBBOLETH_DISCOVERY_URL=https://wayf.aai.dfn.de/DFN-AAI-Test/wayf
This is the so-called "Where-Are-You-From", i.e. IdP Discovery Service URL.

* SHIBBOLETH_SKIP_DS_WITH_IDP=https://idp.daasi.de/idp/shibboleth
If you want to direct SSO to a particular IdP that is part of the below federation, you can use this variable for the IdP's entityID. It will skip the Discovery Service.

* SHIBBOLETH_METADATA_URL=http://www.aai.dfn.de/fileadmin/metadata/dfn-aai-test-metadata.xml
This is the Metadata Location of the SAML Higher Education federation, see https://doku.tid.dfn.de/de:metadata

Furthermore, before building the container, it needs to have valid certificates for SAML communication. You can create them by using the following steps:
´´´
cd docker_containers/docker-shibboleth-sp/
chmod +x keygen.sh
./keygen.sh -h your.host.name -e https://your.host.name/shibboleth -y 3
mv sp-cert.pem sp-key.pem shibboleth/
```

Then the container can be started. Before you can use the SP, make
sure to go to https://your.host.name/Shibboleth.sso/Metadata, download
its contents and register these SP metadata in the federation, such
that the IdPs will know about your SP.


