#!/usr/bin/env dub
/+ dub.sdl:
    name "d8p2"
+/

void main()
{
  import std.stdio : write, writeln, stdin, lines;

  int[][] heights = [];

  foreach (string line; lines(stdin))
  {
    import std.string : stripRight;

    int[] working = [];
    foreach (c; line.stripRight)
      working ~= c - '0';

    heights ~= working;
  }

  int score(int yDir, int xDir, int yIdx, int xIdx, int height, int count)
  {
    auto nextY = yIdx + yDir;
    auto nextX = xIdx + xDir;

    // reached edge
    if (nextX < 0
      || nextY < 0
      || nextX >= heights[yIdx].length
      || nextY >= heights.length)
      return count;

    // next tree is obscuring
    if (heights[nextY][nextX] >= height)
      return count + 1;

    // walk!
    return score(yDir, xDir, nextY, nextX, height, count + 1);
  }

  int bestTreeScore;

  for (int y; y < heights.length; y++)
    for (int x; x < heights[y].length; x++)
    {
      auto treeScore = score(1, 0, y, x, heights[y][x], 0)
        * score(-1, 0, y, x, heights[y][x], 0)
        * score(0, 1, y, x, heights[y][x], 0)
        * score(0, -1, y, x, heights[y][x], 0);

      if (treeScore > bestTreeScore)
        bestTreeScore = treeScore;
    }

  write(bestTreeScore);
}
