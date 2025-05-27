#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <arpa/inet.h>

int main(int argc, char* argv[])
{
  char *ip = "127.0.0.1";
  int port = 727;

  int sock;
  struct sockaddr_in addr;
  socklen_t addr_size;
  char buffer[1024];
  int n;

  sock = socket(AF_INET, SOCK_STREAM, 0);
  if (sock < 0)
  {
    perror("[-]Socket error\n");
    exit(1);
  }
  printf("[+]TCP server socket created.\n");

  memset(&addr, "\0", sizeof(addr));
  addr.sin_family = AF_INET;
  addr.sin_port = port;
  addr.sin_addr.s_addr = inet_addr(ip);

  connect(sock, (struct sockaddr*) &addr, sizeof(addr));
  printf("[+]Connected to server!\n");

  bzero(buffer, sizeof(buffer));
  strcpy(buffer, "Hiii ! :3");
  printf("Client: %s\n", buffer);
  send(sock, buffer, strlen(buffer), 0);

  bzero(buffer, sizeof(buffer));
  recv(sock, buffer, sizeof(buffer), 0);
  printf("[!]Server: %s\n", buffer);

  close(sock);
  printf("Disconnected from server.\n");
  return 0;
};
