# docker-nginx-ldap
Dockerfile for nginx with ldap config

Here is vhost file example of ldap configuration:

```
events {
    worker_connections  1024;
}


http {

    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;

    ldap_server ldapserver {
        url ${ldap.url} 
        binddn "${ldap.account}";
        binddn_passwd ${ldap.password};
        group_attribute ${ldap.group_attribute};
        group_attribute_is_dn on;
        satisfy all;
    }

    server {

        listen 80;
        server_name ${hostname};

        error_log /var/log/nginx/error.log debug;
        access_log /var/log/nginx/access.log;

        auth_ldap "Forbidden";
        auth_ldap_servers ldapserver;

        location / {
            root html;
            index index.html index.htm;
        }

        error_page 500 502 503 504  /50x.html;
        location = /50x.html {
            root html;
        }

    }

}
```
