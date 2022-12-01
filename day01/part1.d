#!/usr/bin/env dub
/+ dub.sdl:
    name "d1p1"
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

  import std.algorithm : maxElement;

  write(maxElement(inputs));
}
