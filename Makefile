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

new_migration:
	migrate create -ext sql -dir db/migration -seq $(name)

sqlc:
	sqlc generate

test:
	go test -v -cover -short ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/frank5487/tx_system/db/sqlc Store

proto:
	rm -f pb/*.go
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
	--go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
	proto/*.proto

redis:
	sudo docker run --name redis -p 6379:6379 -d redis:7-alpine

.PHONY: postgres, createdb, dropdb initSchema migrateup migratedown migrateup1 migratedown1 new_migration sqlc test server mock proto redis
