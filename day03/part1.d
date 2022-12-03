#!/usr/bin/env dub
/+ dub.sdl:
    name "d3p1"
+/

int priority(char c)
{
  import std.string : toUpper;
  return c.toUpper == c
    ? (27 + c - 'A')
    : (1 + c - 'a');
}

void main()
{
  import std.stdio : write, stdin, lines;
  import std.string : indexOf;

  int sum;

  foreach (string line; lines(stdin))
  {
    auto firstHalf = line[0 .. $ / 2];
    auto secondHalf = line[$ / 2 .. $ - 1];

    foreach (char c; firstHalf)
    if (indexOf(secondHalf, c) != -1)
    {
      sum += priority(c);
      break;
    }
  }

  write(sum);
}
