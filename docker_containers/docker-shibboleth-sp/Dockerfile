FROM centos:centos7

LABEL DAASI International GmbH

EXPOSE 80 443

COPY entrypoint.sh /

RUN yum -y update && \
    curl http://download.opensuse.org/repositories/security://shibboleth/CentOS_7/security:shibboleth.repo -o /etc/yum.repos.d/shibboleth.repo && \
    yum -y install httpd mod_ssl shibboleth  && \
    yum -y clean all

COPY shibboleth/ /etc/shibboleth/

COPY httpd/ /etc/httpd/conf.d/

RUN test -d /var/run/lock || mkdir -p /var/run/lock && \
    test -d /var/lock/subsys/ || mkdir -p /var/lock/subsys/ \
    && chmod +x /etc/shibboleth/shibd-redhat \
    && echo $'export LD_LIBRARY_PATH=/opt/shibboleth/lib64:$LD_LIBRARY_PATH\n'\
       > /etc/sysconfig/shibd \
    && sed -i 's/ErrorLog "logs\/error_log"/ErrorLog \/dev\/stdout/g' /etc/httpd/conf/httpd.conf \
    && echo -e "\nErrorLogFormat \"httpd-error [%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i\"" >> /etc/httpd/conf/httpd.conf \
    && sed -i 's/CustomLog "logs\/access_log" combined/CustomLog \/dev\/stdout \"httpd-combined %h %l %u %t \\\"%r\\\" %>s %b \\\"%{Referer}i\\\" \\\"%{User-Agent}i\\\"\"/g' /etc/httpd/conf/httpd.conf \
    && sed -i 's/ErrorLog logs\/ssl_error_log/ErrorLog \/dev\/stdout/g' /etc/httpd/conf.d/ssl.conf \
    && sed -i 's/<\/VirtualHost>/ErrorLogFormat \"httpd-ssl-error [%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\\ %a] %M% ,\\ referer\\ %{Referer}i\"\n<\/VirtualHost>/g' /etc/httpd/conf.d/ssl.conf \
    && sed -i 's/CustomLog logs\/ssl_request_log/CustomLog \/dev\/stdout/g' /etc/httpd/conf.d/ssl.conf \
    && sed -i 's/TransferLog logs\/ssl_access_log/TransferLog \/dev\/stdout/g' /etc/httpd/conf.d/ssl.conf
    
ENTRYPOINT ["/entrypoint.sh"]