#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int	ft_putchar(int c)
{
	return (write(1, &c, 1));
}

void	ft_ptrprint(unsigned long long value)
{
	if (!value)
	{
		write(1, "(nil)", 5);
		return ;
	}
	write(1, "0x", 2);
	ft_uhexprint(value, "0123456789abcdef");
}

void	ft_uhexprint(unsigned long long nbr, char *base)
{
	if (nbr < 16)
		ft_putchar(base[nbr]);
	else
	{
		ft_uhexprint(nbr / 16, base);
		ft_putchar(base[nbr % 16]);
	}
}

int main(void)
{
  short int* test = malloc(1);
  ft_ptrprint(&test);
  free(test);
  return 0;
}
