#!/usr/bin/env dub
/+ dub.sdl:
    name "d9p2"
+/

import std.typecons : tuple, Tuple;

void moveRope(Tuple!(int, int)[] rope, int xDir, int yDir)
{
  import std.math : abs;

  rope[0][0] += xDir;
  rope[0][1] += yDir;

  for (int i; i + 1 < rope.length; i++)
  {
    auto xDiff = (rope[i][0] - rope[i + 1][0]);
    auto yDiff = (rope[i][1] - rope[i + 1][1]);
    if (abs(xDiff) > 1 || abs(yDiff) > 1)
    {
      // why does the logic have to be so much more annoying
      // i cry, it was so simple for just one tail :(
      if (xDiff == 0 || yDiff == 0)
      {
        // in line with target
        rope[i + 1][0] += xDiff / 2;
        rope[i + 1][1] += yDiff / 2;
      }
      else
      {
        // need to move diagonally
        // normalise both to +1 or -1
        auto normXDiff = xDiff / abs(xDiff);
        auto normYDiff = yDiff / abs(yDiff);
        rope[i + 1][0] += normXDiff;
        rope[i + 1][1] += normYDiff;
      }
    }
  }
}

void main()
{
  import std.stdio : write, writeln, stdin, lines;

  Tuple!(int, int)[] visited = [];
  auto parts = new Tuple!(int, int)[10];

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

    int xDir;
    int yDir;

    final switch (line[0])
    {
    case 'U':
      yDir++;
      break;
    case 'D':
      yDir--;
      break;
    case 'R':
      xDir++;
      break;
    case 'L':
      xDir--;
      break;
    }

    auto amount = line[2 .. $].stripRight.to!int;

    for (int i; i < amount; i++)
    {
      moveRope(parts, xDir, yDir);

      pushPosition(tuple(parts[$ - 1][0], parts[$ - 1][1]));
    }
  }

  write(visited.length);
}
