#!/usr/bin/env dub
/+ dub.sdl:
    name "d10p1"
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
  int strength;

  foreach (string line; lines(stdin))
  {
    auto instruction = line.stripRight;

    auto preCycle = state.cycle;
    auto preX = state.X;

    if (instruction == "noop")
    {
      state.cycle++;
    }

    else if (instruction.startsWith("addx"))
    {
      state.X += instruction[5 .. $].to!int;
      state.cycle += 2;
    }

    if ((state.cycle + 20) % 40 == 0)
      strength += state.cycle * preX;
    else if ((state.cycle + 20) % 40 < (preCycle + 20) % 40)
    {
      auto intendedCycle = state.cycle - (state.cycle + 20) % 40;
      strength += intendedCycle * preX;
    }
  }
  
  write(strength);
}
