all: clean build

clean:
	kubectl delete job kaniko-build --ignore-not-found

build: export CLUSTER_DOMAIN=cluster.local
build: export NAMESPACE=default
build: export CA_URL=step-certificates.system-certificates.svc.cluster.local
build: export CA_FINGERPRINT=c0ec43883e69659ac3e79fcfbd8ca158a6f2ba14b6eb22beabab7b3ad1121040
build: export SOURCE=ssh://test-git.int.oertelnet.com:23231/openldap-docker
build: export REGISTRY=test-docker-registry.int.oertelnet.com
build: export CONTAINER=openldap:latest
build:
	envsubst<kaniko-build.yaml|kubectl apply -f - --wait
	kubectl wait --for=condition=complete job/kaniko-build --timeout=120s
	kubectl logs job/kaniko-build -f kaniko
