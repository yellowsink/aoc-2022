#!/usr/bin/env dub
/+ dub.sdl:
    name "d12p2"
+/

int bfs(int endX, int endY, int startX, int startY, int[][] heights)
{
  import std.typecons : tuple, Tuple;

  int depth;
  Tuple!(int, int)[] current = [tuple(startX, startY)];
  Tuple!(int, int)[] visited = [current[0]];

  while (true)
  {
    if (current.length == 0)
      // dead end
      return int.max;

    bool found;
    foreach (c; current)
      if (c[0] == endX && c[1] == endY)
      {
        found = true;
        break;
      }
    if (found)
      break;

    Tuple!(int, int)[] next = [];

    foreach (c; current)
      foreach (place; [
          tuple(c[0] + 1, c[1]),
          tuple(c[0] - 1, c[1]),
          tuple(c[0], c[1] + 1),
          tuple(c[0], c[1] - 1)
        ])
        if (place[0] >= 0
          && place[1] >= 0
          && place[1] < heights.length
          && place[0] < heights[place[1]].length
          && heights[place[1]][place[0]] <= heights[c[1]][c[0]] + 1)
        {
          bool alreadyVisited;
          foreach (v; visited)
            if (v[0] == place[0] && v[1] == place[1])
            {
              alreadyVisited = true;
              break;
            }
          if (alreadyVisited)
            continue;

          next ~= place;
          visited ~= place;
        }

    current = next;

    depth++;
  }

  return depth;
}

void main()
{
  import std.stdio : write, writeln, stdin, lines;
  import std.string : stripRight, startsWith, split;
  import std.algorithm : minElement;

  int[][] heights;
  int endX;
  int endY;

  int yIdx;
  foreach (string line; lines(stdin))
  {
    int[] row = [];
    int xIdx;
    foreach (height; line.stripRight)
    {
      if (height == 'S')
        row ~= 0;
      else if (height == 'E')
      {
        endX = xIdx;
        endY = yIdx;
        row ~= 'z' - 'a';
      }
      else
        row ~= height - 'a';

      xIdx++;
    }

    heights ~= row;

    yIdx++;
  }
  
  int[] amounts = [];

  for (int y; y < heights.length; y++)
  for (int x; x < heights[y].length; x++)
    if (heights[y][x] == 0)
      amounts ~= bfs(endX, endY, x, y, heights);

  write(minElement(amounts));
}
