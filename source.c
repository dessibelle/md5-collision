#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// Toggle this on to print collision bytes in executable
#define DEBUG 0

int good(int argc, char *argv[])
{
  printf("Hello world!\n");
  return 0;
}

int evil(int argc, char *argv[])
{
  printf("You have been pwned\n");
  printf("Deleting all files\n\n");

  for (int i = 0; i <= 100; i++)
  {
    printf("\x1b[1F");
    printf("Progress %3i%%...\n", i);
    usleep(25000);
  }
  printf("LOL, just kidding, bye.\n");

  return 0;
}

int main(int argc, char *argv[])
{
  FILE *f = fopen(argv[0], "rb");

  unsigned int num_addrs = 8;
  int addrs[] = {
    0x00000693,
    0x000006ad,
    0x000006ae,
    0x000006bb,
    0x000006d3,
    0x000006ed,
    0x000006ee,
    0x000006fb
  };
  int bytes[num_addrs];

  for (int i = 0; i < num_addrs; i++)
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
