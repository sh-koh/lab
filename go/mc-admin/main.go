package main

import (
	"context"
	"fmt"
	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/client"
	"os"
	"slices"
)

var args = []string{
	"start",
	"stop",
	"restart",
	"reload",
	"send",
	"list",
	"help",
}

const help = `mc-admin { start | stop | restart | reload | send | list } CONTAINER_NAME
  start:    Start the server
  stop:     Stop the selected server
  restart:  Restart the selected server
  reload:   Reload the selected server
  send:     Send a minecraft command (ex: /kickall) to the selected server
  list:     List all servers and showing their states
`

func start(cli *client.Client, ctx context.Context) {
	fmt.Println("Starting the server...")
}

func stop(cli *client.Client, ctx context.Context) {
	fmt.Println("Stopping the server...")
}

func restart(cli *client.Client, ctx context.Context) {
	fmt.Println("Restarting the server...")
}

func reload(cli *client.Client, ctx context.Context) {
	fmt.Println("Reloading the server...")
}

func send(cli *client.Client, ctx context.Context, i int) {
	fmt.Printf("'%s' sent to the server", os.Args[i+1])
}

func list(cli *client.Client, ctx context.Context) {
	containers, err := cli.ContainerList(ctx, container.ListOptions{})
	if err != nil {
		panic(err)
	}
	for _, ctr := range containers {
		fmt.Printf("%s %s\n", ctr.ID, ctr.Image)
	}
}

func cmd(cli *client.Client, ctx context.Context) {
	for i, v := range os.Args[1:] {
		if !slices.Contains(args, v) {
			fmt.Printf("You did not provide valid arguments.\n%s", help)
			break
		}
		switch v {
		case "start":
			start(cli, ctx)
			break
		case "stop":
			stop(cli, ctx)
			break
		case "restart":
			restart(cli, ctx)
			break
		case "reload":
			reload(cli, ctx)
			break
		case "send":
			send(cli, ctx, i)
			break
		case "list":
			list(cli, ctx)
			break
		case "help":
			fmt.Print(help)
			break
		case "":
			fmt.Print(help)
			break
		default:
			fmt.Print(help)
			break
		}
	}
}

func main() {
	ctx := context.Background()
	cli, err := client.NewClientWithOpts(client.FromEnv)
	if err != nil {
		panic(err)
	}
	defer cli.Close()
	cli.NegotiateAPIVersion(ctx)

	cmd(cli, ctx)
}
