#!/usr/bin/env dub
/+ dub.sdl:
    name "d3p2"
+/

int priority(char c)
{
  import std.string : toUpper;

  return c.toUpper == c
    ? (27 + c - 'A') : (1 + c - 'a');
}

void main()
{
  import std.stdio : write, stdin, lines;
  import std.string : indexOf;

  string[] input = [];
  foreach (string line; lines(stdin))
    input ~= line;

  int sum;

  for (auto i = 0; i < input.length; i += 3)
  {
    auto set1 = input[i];
    auto set2 = input[i + 1];
    auto set3 = input[i + 2];

    foreach (char c; set1)
      if (indexOf(set2, c) != -1 && indexOf(set3, c) != -1)
      {
        sum += priority(c);
        break;
      }
  }

  write(sum);
}