all: clean build

clean:
	kubectl delete job kaniko-build --ignore-not-found

build: export CLUSTER_DOMAIN=cluster.local
build: export NAMESPACE=default
build: export CA_URL=step-certificates.system-certificates.svc.cluster.local
build: export CA_FINGERPRINT=9e2dc74f3fa96bbf51fb5f0b01ed89a277559e8a4bac1763a4afa03cb80c5c38
build: export SOURCE=ssh://test-git.int.oertelnet.com/openldap-docker
build: export REGISTRY=test-docker-registry.int.oertelnet.com
build: export CONTAINER=openldap:latest
build:
	envsubst<kaniko-build.yaml|kubectl apply -f -
	kubectl wait --for=condition=complete job/kaniko-build --timeout=120s
	kubectl logs job/kaniko-build -f kaniko
