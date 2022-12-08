#!/usr/bin/env dub
/+ dub.sdl:
    name "d8p1"
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

  bool check(int yDir, int xDir, int yIdx, int xIdx, int height)
  {
    auto nextY = yIdx + yDir;
    auto nextX = xIdx + xDir;

    // reached edge
    if (nextX < 0 || nextY < 0 || nextX >= heights[yIdx].length || nextY >= heights.length)
      return true;

    // next tree is obscuring
    if (heights[nextY][nextX] >= height)
      return false;
    
    // walk!
    return check(yDir, xDir, nextY, nextX, height);
  }

  int visible;
  for (int y; y < heights.length; y++)
  for (int x; x < heights[y].length; x++)
  {
    auto isVisible = check(1 , 0 , y, x, heights[y][x])
          || check(-1, 0 , y, x, heights[y][x])
          || check(0 , 1 , y, x, heights[y][x])
          || check(0 , -1, y, x, heights[y][x]);
    
    //writeln(x, ", ", y, ": ", isVisible);
    visible += isVisible;
  }
  


  write(visible);
}
