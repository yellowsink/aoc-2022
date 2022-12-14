#!/usr/bin/env dub
/+ dub.sdl:
    name "d14p2"
+/

void main()
{
  import std.stdio : write, writeln, stdin, lines;
  import std.string : stripRight, startsWith, split;
  import std.conv : to;
  import std.typecons : Tuple, tuple;
  import std.algorithm : min, max;

  Tuple!(int, int)[][] rockLines;

  /* int minX = int.max;
  int minY = int.max;
  int maxX; */
  int maxY;

  bool[Tuple!(int, int)] sandPositions;

  foreach (string line; lines(stdin))
  {
    Tuple!(int, int)[] l = [];
    foreach (chunk; line.stripRight.split(" -> "))
    {
      auto coordRaw = chunk.split(",");
      auto coord = tuple(coordRaw[0].to!int, coordRaw[1].to!int);
      l ~= coord;

      /* minX = min(minX, coord[0]);
      maxX = max(maxX, coord[0]);
      minY = min(minY, coord[1]); */
      maxY = max(maxY, coord[1]);
    }

    rockLines ~= l;
  }

  rockLines ~= [
    tuple(int.min, maxY + 2),
    tuple(int.max, maxY + 2),
  ];

  bool isTaken(int x, int y)
  {
    if (tuple(x, y) in sandPositions)
      return true;

    foreach (line; rockLines)
    {
      auto lastPoint = line[0];
      foreach (point; line[1 .. $])
      {
        // i hope the compiler joins these into a MASSIVE single if stmt :D
        if (point[0] == lastPoint[0]
          && x == point[0]
          && (
            (y >= lastPoint[1] && y <= point[1])
            || (y <= lastPoint[1] && y >= point[1])
          ))
          return true;
        
        if (point[1] == lastPoint[1]
        && y == point[1]
        && (
            (x >= lastPoint[0] && x <= point[0])
            || (x <= lastPoint[0] && x >= point[0])
          ))
          return true;
        
        lastPoint = point;
      }
    }

    return false;
  }

  while (true)
  {
    auto sand = tuple(500, 0);

    while (true)
    {
      if (!isTaken(sand[0], sand[1] + 1))
        sand[1]++;
      
      else if (!isTaken(sand[0] - 1, sand[1] + 1))
      {
        sand[0]--;
        sand[1]++;
      }

      else if (!isTaken(sand[0] + 1, sand[1] + 1))
      {
        sand[0]++;
        sand[1]++;
      }

      else if (sand[0] == 500 && sand[1] == 0)
      {
        write(sandPositions.length + 1);
        return; // i love exiting my program from within two nested while trues
      }
      else break;
    }
    
    sandPositions[sand] = true;
  }
}
