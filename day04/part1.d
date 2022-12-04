#!/usr/bin/env dub
/+ dub.sdl:
    name "d4p1"
+/

import std.typecons : tuple, Tuple;

Tuple!(int, int) range(string s)
{
  import std.conv : to;
  import std.string : split, strip;

  auto splitted = s.strip.split("-");
  return tuple(
    splitted[0].to!int,
    splitted[1].to!int
  );
}

bool contains(Tuple!(int, int) first, Tuple!(int, int) second)
{
  return first[0] >= second[0] && first[1] <= second[1];
}

void main()
{
  import std.stdio : write, stdin, lines;

  int sum;

  foreach (string line; lines(stdin))
  {
    import std.string : split;
    auto splitted = line.split(",");
    auto range1 = range(splitted[0]);
    auto range2 = range(splitted[1]);

    // i love implicit type casting
    sum += contains(range1, range2) || contains(range2, range1);
  }

  write(sum);
}
