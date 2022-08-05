all:
	docker build -t openldap .
	docker push roertel/openldap