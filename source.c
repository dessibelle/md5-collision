#include <stdio.h>
#include <stdlib.h>

// Toggle this on to print collision bytes in executable
#define DEBUG 0

int good(int argc, char *argv[])
{
  printf("I am good\n");
  return 0;
}

int evil(int argc, char *argv[])
{
  printf("I am evil\n");
  return 0;
}

int main(int argc, char *argv[])
{
  FILE *f = fopen(argv[0], "rb");

  int addrs[] = {
    0x00000693,
    0x000006ad,
    0x000006bb,
    0x000006d3,
    0x000006ed,
    0x000006fb
  };
  int bytes[6];

  for (int i = 0; i < 6; i++)
  {
    fseek(f, addrs[i], SEEK_SET);
    bytes[i] = fgetc(f);
#if DEBUG
    printf("Found byte %i (%x)\n", bytes[i], bytes[i]);
#endif
  }
  fclose(f);

  if (bytes[0] == 0xff) // Toggle this bit according to first byte in collision
  {
	  return evil(argc, argv);
  }

  return good(argc, argv);
}
