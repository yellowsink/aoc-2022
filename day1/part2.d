#!/usr/bin/env dub
/+ dub.sdl:
    name "d1p2"
+/

void main()
{
  import std.stdio : write, stdin, lines;

  int[] inputs = [0];
  auto i = 0;
  foreach (string line; lines(stdin))
  {
    import std.conv : to;
    import std.string : stripRight;

    if (line == "\n")
    {
      i++;
      inputs ~= 0;
    }
    else
      inputs[i] += line.stripRight.to!int;
  }

  import std.algorithm : partialSort, sum;

  // we only need the first 3 sorted!
  // the default sort predicate is "a < b" but
  // we want descending not ascending ;)
  partialSort!"a > b"(inputs, 3);

  write(inputs[0 .. 3].sum);
}
