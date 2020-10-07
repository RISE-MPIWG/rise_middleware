## Overview
This Docker image is Apache 2.4 with Shibboleth SP 3.0 installed running on CentOS 7 Base Image.

## Logs
Logs for httpd and shibd have been configured to output to the console so that Docker's logging facilities are supported. Each of these logs have been prefaced with an identifier that indicates the type of entry being outputted: `httpd-error`, `httpd-combined`, `sp-shibd`, `sp-native`, `sp-transaction`, `sp-sign`, etc.
