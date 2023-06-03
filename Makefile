DB_URL=postgresql://root:123456@localhost:5432/tx_system?sslmode=disable

postgres:
	sudo docker run --name postgres14 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=123456 -d postgres:14-alpine

createdb:
	sudo docker exec -it postgres14 createdb --username=root --owner=root tx_system

dropdb:
	sudo docker exec -it postgres14 dropdb tx_system
	
initSchema:
	migrate create -ext sql -dir db/migration -seq init_schema

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover -short ./...

server:
	go run main.go

.PHONY: postgres, createdb, dropdb initSchema migrateup migratedown migrateup1 migratedown1 sqlc test server
