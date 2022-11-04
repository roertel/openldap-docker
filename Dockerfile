FROM debian:stable-slim

RUN apt-get -yqq update \
 && DEBIAN_FRONTEND=noninteractive apt-get -yqq --no-install-recommends \
    install slapd ldap-utils gettext-base inotify-tools vim-tiny openssl \
 && rm -rf /var/log/apt /var/log/*.log /var/cache/apt /var/cache/debconf

COPY src/* /usr/local/bin/

RUN mkdir -p "/ldap" \
 && chown -R openldap:openldap /ldap \
 && chmod 0700 /ldap \
 && chmod +x /usr/local/bin/* \
 && ln -s /usr/local/bin/init /entrypoint \
 && ln -s /usr/local/bin/healthz /healthz \
 && echo "done"

ENV HOME /ldap
USER openldap

ENTRYPOINT ["/entrypoint"]
