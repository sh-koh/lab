#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <arpa/inet.h>

int main(int argc, char* argv[])
{
  char *ip = "127.0.0.1";
  int port = 727;

  int srv_sock, cli_sock;
  struct sockaddr_in srv_addr, cli_addr;
  socklen_t addr_size;
  char buffer[1024];
  int n;

  srv_sock = socket(AF_INET, SOCK_STREAM, 0);
  if (srv_sock < 0)
  {
    perror("[-]Socket error\n");
    exit(1);
  }
  printf("[+]TCP server socket created.\n");

  memset(&srv_addr, '\0', sizeof(srv_addr));
  srv_addr.sin_family = AF_INET;
  srv_addr.sin_port = port;
  srv_addr.sin_addr.s_addr = inet_addr(ip);

  n = bind(srv_sock, (struct sockaddr*)&srv_addr, sizeof(srv_addr));
  if (n < 0)
  {
    perror("[-]Bind error\n");
    exit(1);
  }
  printf("[+]Bind to the port: %d\n", port);

  listen(srv_sock, 5);
  printf("Listening...\n");

  while (1)
  {
    addr_size = sizeof(cli_addr);
    cli_sock = accept(srv_sock, (struct sockaddr*) &cli_addr, &addr_size);
    printf("[+]Client connected!\n");

    bzero(buffer, sizeof(buffer));
    recv(cli_sock, buffer, sizeof(buffer), 0);
    printf("[!]Client: %s\n", buffer);

    bzero(buffer, sizeof(buffer));
    strcpy(buffer, "Hiii ! server here ;3");
    printf("Server: %s\n", buffer);
    send(cli_sock, buffer, strlen(buffer), 0);

    close(cli_sock);
    printf("[+]Client disconnected.\n");
  }

  return 0;
};
