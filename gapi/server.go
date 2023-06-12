package gapi

import (
	"fmt"
	db "github.com/frank5487/tx_system/db/sqlc"
	"github.com/frank5487/tx_system/pb"
	"github.com/frank5487/tx_system/token"
	"github.com/frank5487/tx_system/util"
	"github.com/frank5487/tx_system/worker"
)

// Server serves gRPC requests for our banking service.
type Server struct {
	pb.UnimplementedTxSystemServer
	config          util.Config
	store           db.Store
	tokenMaker      token.Maker
	taskDistributor worker.TaskDistributor
}

// NewServer creates a new gRPC server.
func NewServer(config util.Config, store db.Store, taskDistributor worker.TaskDistributor) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}

	server := &Server{
		config:          config,
		store:           store,
		tokenMaker:      tokenMaker,
		taskDistributor: taskDistributor,
	}

	return server, nil
}
