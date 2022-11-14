all: clean build

clean:
	kubectl delete job kaniko-build --ignore-not-found

build: export CONTAINER=openldap:0.1.2
build:
	envsubst<kaniko-build.yaml|kubectl apply -f - --wait
	kubectl wait --for=condition=complete job/kaniko-build --timeout=120s
	kubectl logs job/kaniko-build -f kaniko
