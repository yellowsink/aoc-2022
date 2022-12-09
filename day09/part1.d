#!/usr/bin/env dub
/+ dub.sdl:
    name "d9p1"
+/

void main()
{
  import std.stdio : write, writeln, stdin, lines;
  import std.typecons : tuple, Tuple;

  Tuple!(int, int)[] visited = [];
  int xHead;
  int yHead;
  int xTail;
  int yTail;

  void pushPosition(Tuple!(int, int) pos)
  {
    foreach (p; visited)
      if (p[0] == pos[0] && p[1] == pos[1])
        return;
    
    visited ~= pos;
  }

  foreach (string line; lines(stdin))
  {
    import std.string : stripRight;
    import std.conv : to;

    auto amount = line[2 .. $].stripRight.to!int;

    for (int i; i < amount; i++)
    {
      final switch (line[0])
      {
      case 'U':
        yHead++;
        break;
      case 'D':
        yHead--;
        break;
      case 'R':
        xHead++;
        break;
      case 'L':
        xHead--;
        break;
      }

      import std.math : abs;

      if (abs(xHead - xTail) > 1 || abs(yHead - yTail) > 1)
      {
        final switch (line[0])
        {
        case 'U':
          yTail = yHead - 1;
          xTail = xHead;
          break;
        case 'D':
          yTail = yHead + 1;
          xTail = xHead;
          break;
        case 'R':
          xTail = xHead - 1;
          yTail = yHead;
          break;
        case 'L':
          xTail = xHead + 1;
          yTail = yHead;
          break;
        }
      }

      pushPosition(tuple(xTail, yTail));
    }
  }

  write(visited.length);
}
