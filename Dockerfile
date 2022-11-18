FROM debian:stable-slim

ARG LDAP_VERSION="2.4.57+dfsg-3+deb11u1"
ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF

LABEL org.label-schema.schema-version = "1.0"
LABEL org.label-schema.name = "OpenLDAP"
LABEL org.label-schema.version = ${LDAP_VERSION}
LABEL org.label-schema.description = "OpenLDAP server in a container"
LABEL org.label-schema.url = ${VCS_URL}
LABEL org.label-schema.build-date = ${BUILD_DATE}
LABEL org.label-schema.vcs-url = ${VCS_URL}
LABEL org.label-schema.vcs-ref = ${VCS_REF}

RUN apt-get -yqq update \
 && DEBIAN_FRONTEND=noninteractive apt-get -yqq --no-install-recommends \
    install slapd=${LDAP_VERSION} ldap-utils gettext-base vim-tiny openssl \
 && rm -rf /var/log/apt /var/log/*.log /var/cache/apt /var/cache/debconf

COPY src/* /usr/local/bin/

RUN mkdir -p "/ldap" \
 && chown -R openldap:openldap /ldap \
 && chmod 0700 /ldap \
 && chmod +x /usr/local/bin/* \
 && ln -st / /usr/local/bin/init /usr/local/bin/healthz \
 && echo "done"

ENV HOME /ldap
USER openldap

ENTRYPOINT ["/init"]
