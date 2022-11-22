# openldap-docker

A basic OpenLDAP installation on Debian for use in a K8s cluster

## Environment

|Name|Default|Description|
|---|---|---|
|BASEDIR|/ldap|Base directory for other directories|
|LDAPDIR|$BASEDIR/slapd.d|LDAP database directory (persist if you want to keep your settings)|
|SECRETS|$BASEDIR/secrets|Secrets to inject into scripts, TLS, etc.|
|LDIFDIR|$BASEDIR/config|Directory for LDAP DB configuration|
|CERTDIR|$BASEDIR/tls|Directory to watch for changes to certificates|
|RUN_DIR|$BASEDIR/run|Run dir (pid files, sockets, etc)|

### Secrets Directory

The SECRETS directory is watched for changes. When changes are detected, a script will read the secret into an environment variable named as the basename of the file (extensions are not stripped) and prefix it with `LDAP_`. For example a secret file named `admin_password` will result in an environment variable named `LDAP_admin_password`. The contents of the secret file will be hashed through `slappaswd` so that it can be used directly in your LDIF files.  You can then use this variable in your scripts.

### LDIF Directory

Files in this directory named as `init*.ldif` are loaded via `slapadd` prior to starting ldap but only if LDAP was not already initialized (ie: `$LDAPDIR` doesn't already exist). Changes to these files post-initialization will not have any effect.

Files in this directory named as `config*.ldif` will trigger a call to `ldapmodify -c` with the contents of the file filtered through `envsubst` for injection of secrets or other environment variables. This will be called on every restart of the service and may display duplicate entry errors as a result.

### Certificate Directory

Files in this directory are for TLS over LDAP (ie: LDAPS). A script will trigger LDAP to reload the certificates when they are close to expiring. It's up to you to renew them manually or use cert-manager.
