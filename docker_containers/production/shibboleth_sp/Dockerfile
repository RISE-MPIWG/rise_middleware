FROM centos:centos7

LABEL DAASI International GmbH

EXPOSE 222

COPY entrypoint.sh /

RUN yum -y update && \
    curl http://download.opensuse.org/repositories/security://shibboleth/CentOS_7/security:shibboleth.repo -o /etc/yum.repos.d/shibboleth.repo && \
    yum -y install httpd shibboleth  && \
    yum -y clean all

COPY shibboleth/ /etc/shibboleth/

RUN chown shibd:shibd /etc/shibboleth/*

COPY httpd/ /etc/httpd/conf.d/

RUN test -d /var/run/lock || mkdir -p /var/run/lock && \
    test -d /var/lock/subsys/ || mkdir -p /var/lock/subsys/ \
    && chmod +x /etc/shibboleth/shibd-redhat \
    && echo $'export LD_LIBRARY_PATH=/opt/shibboleth/lib64:$LD_LIBRARY_PATH\n'\
       > /etc/sysconfig/shibd \
    && sed -i 's/ErrorLog "logs\/error_log"/ErrorLog \/dev\/stdout/g' /etc/httpd/conf/httpd.conf \
    && echo -e "\nErrorLogFormat \"httpd-error [%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i\"" >> /etc/httpd/conf/httpd.conf
ENTRYPOINT ["/entrypoint.sh"]