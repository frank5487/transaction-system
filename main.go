package main

import (
	"database/sql"
	"github.com/frank5487/tx_system/api"
	db "github.com/frank5487/tx_system/db/sqlc"
	_ "github.com/lib/pq"
	"log"
)

const (
	dbDriver      = "postgres"
	dbSource      = "postgresql://root:123456@localhost:5432/tx_system?sslmode=disable"
	serverAddress = "0.0.0.0:8080"
)

func main() {
	//config, err := util.LoadConfig(".")
	//if err != nil {
	//	log.Fatal("cannot load config: ", err)
	//}

	//conn, err := sql.Open(config.DBDriver, config.DBSource)
	conn, err := sql.Open(dbDriver, dbSource)
	if err != nil {
		log.Fatal("cannot connect to db: ", err)
	}

	store := db.NewStore(conn)
	server, err := api.NewServer(store)

	//err = server.Start(config.ServerAddress)
	err = server.Start(serverAddress)

	if err != nil {
		log.Fatal("cannot start server: ", err)
	}
}
