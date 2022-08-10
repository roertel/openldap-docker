all:
	docker build -t openldap .
	docker image tag openldap docker.io/roertel/openldap
	docker push roertel/openldap