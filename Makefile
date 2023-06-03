
postgres:
	sudo docker run --name postgres14 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=123456 -d postgres:14-alpine

createdb:
	sudo docker exec -it postgres14 createdb --username=root --owner=root tx_system

dropdb:
	sudo docker exec -it postgres14 dropdb tx_system

.PHONY: postgres, createdb, dropdb