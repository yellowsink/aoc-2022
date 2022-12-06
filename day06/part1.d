#!/usr/bin/env dub
/+ dub.sdl:
    name "d6p1"
+/
void main()
{
  import std.stdio : write, writeln, stdin, chunks;

  char[4] lastFour;
  int idx;

  foreach (ubyte[] line; chunks(stdin, 4096))
  foreach (char c; line)
  {
    idx++;

    // shift
    lastFour[0] = lastFour[1];
    lastFour[1] = lastFour[2];
    lastFour[2] = lastFour[3];
    lastFour[3] = c;

    // ew
    if (
      idx >=4 
    && lastFour[0] != lastFour[1]
    && lastFour[0] != lastFour[2]
    && lastFour[0] != lastFour[3]
    && lastFour[1] != lastFour[2]
    && lastFour[1] != lastFour[3]
    && lastFour[2] != lastFour[3])
      break;
  }

  write(idx);
}
