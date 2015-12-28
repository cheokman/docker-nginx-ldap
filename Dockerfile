FROM centos:centos6
MAINTAINER Ben Wu <wucheokman@gmail.com>

RUN echo "NETWORKING=yes" > /etc/sysconfig/network
ENV NGINX_VERSION release-1.9.6

RUN yum -y update && yum -y install \
    which \
    tar \
    openssl-devel \
    git \
    glibc-headers \
    autoconf \
    gcc-c++ \
    glibc-devel \
    patch \
    readline-devel \
    bzip2 \
    automake \
    libtool \
    bison \
    pcre \
    pcre-devel \
    openldap-devel \
    && yum clean all

RUN mkdir /var/log/nginx \
	&& mkdir /etc/nginx \
	&& mkdir /etc/nginx/conf.d \
	&& cd ~ \
	&& git clone https://github.com/kvspb/nginx-auth-ldap.git \
	&& git clone https://github.com/nginx/nginx.git \
	&& cd ~/nginx \
	&& git checkout tags/${NGINX_VERSION} \
	&& ./auto/configure \
		--add-module=/root/nginx-auth-ldap \
		--with-http_ssl_module \
		--with-debug \
		--conf-path=/etc/nginx/nginx.conf \ 
		--sbin-path=/usr/sbin/nginx \ 
		--pid-path=/var/log/nginx/nginx.pid \ 
		--error-log-path=/var/log/nginx/error.log \ 
		--http-log-path=/var/log/nginx/access.log \ 
	&& make install \
	&& cd .. \
	&& rm -rf nginx-auth-ldap \
	&& rm -rf nginx 

COPY config/nginx.conf /etc/nginx/nginx.conf
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
