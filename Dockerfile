FROM debian:stable-slim

COPY src/init src/ldif_watch /usr/local/bin/

RUN apt-get -yqq update \
 && DEBIAN_FRONTEND=noninteractive apt-get -yqq --no-install-recommends \
    install slapd gettext-base inotify-tools vim-tiny \
 && mkdir -p "/ldap" \
 && chown -R openldap:openldap /ldap \
 && chmod 0700 /ldap \
 && chmod +x /usr/local/bin/* \
 && echo "done"

USER openldap

ENTRYPOINT ["/usr/local/bin/init"]
