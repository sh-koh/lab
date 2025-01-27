#include <stdio.h>
#include <unistd.h>


struct ipAddr {
  unsigned char a;
  unsigned char b;
  unsigned char c;
  unsigned char d;
};

struct netMask {
  unsigned char a;
  unsigned char b;
  unsigned char c;
  unsigned char d;
};

int main(int argc, char **argv)
{
  struct ipAddr my_ip = {192, 168, 1, 201};
  struct netMask my_mask = {255, 255, 255, 0};

  printf("ip: %u.%u.%u.%u\n", my_ip.a, my_ip.b, my_ip.c, my_ip.d);
  printf("mask: %u.%u.%u.%u\n", my_mask.a, my_mask.b, my_mask.c, my_mask.d);
  printf("size: %zu byte", sizeof(my_ip));
  return 0;
};
