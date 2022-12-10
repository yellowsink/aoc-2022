#!/usr/bin/env dub
/+ dub.sdl:
    name "d10p2"
+/

struct MachineState
{
  int cycle;
  int X = 1;
}

void main()
{
  import std.stdio : write, writeln, stdin, lines;
  import std.string : stripRight, startsWith;
  import std.conv : to;

  auto state = MachineState();
  int i;

  int crtWidth = 40;
  int crtI = 99;
  bool[40][] pixels = [];

  void pushPixel(int x)
  {
    import std.math : abs;

    if (crtI >= crtWidth)
    {
      crtI = 0;
      bool[40] row;
      pixels ~= row;
    }
    
    pixels[$ - 1][crtI] = abs(crtI - x) <= 1;
    crtI++;
  }

  foreach (string line; lines(stdin))
  {
    auto instruction = line.stripRight;

    auto preCycle = state.cycle;
    auto preX = state.X;

    if (instruction == "noop")
    {
      state.cycle++;
      pushPixel(state.X);
    }

    else if (instruction.startsWith("addx"))
    {
      pushPixel(state.X);
      pushPixel(state.X);

      state.X += instruction[5 .. $].to!int;
      state.cycle += 2;
    }
  }
  
  foreach (row; pixels)
  {
    foreach (pixel; row)
      write(pixel ? '#' : '.');
    writeln();
  }
}
