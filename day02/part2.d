#!/usr/bin/env dub
/+ dub.sdl:
    name "d1p1"
+/

enum RPS
{
  Rock,
  Paper,
  Scissors
}

enum WinLoseDraw
{
  Lose = 0,
  Draw = 3,
  Win = 6
}

RPS parseRPS(char c)
{
  return cast(RPS)(c - 'A');
}

WinLoseDraw parseWLD(char c)
{
  return cast(WinLoseDraw)((c - 'X') * 3);
}

RPS respond(RPS theirs, WinLoseDraw wld)
{
  if (wld == WinLoseDraw.Draw)
    return theirs;

  if (wld == WinLoseDraw.Win) final switch (theirs)
  {
  case RPS.Rock:
    return RPS.Paper;
  case RPS.Paper:
    return RPS.Scissors;
  case RPS.Scissors:
    return RPS.Rock;
  }

  final switch (theirs)
  {
  case RPS.Rock:
    return RPS.Scissors;
  case RPS.Paper:
    return RPS.Rock;
  case RPS.Scissors:
    return RPS.Paper;
  }
}

void main()
{
  import std.stdio : write, stdin, lines;
  import std.conv : to;

  int score;

  foreach (string line; lines(stdin))
  {
    auto theirs = parseRPS(line[0]);
    auto outcome = parseWLD(line[2]);
    auto ours = respond(theirs, outcome);

    score += outcome + 1 + ours;
  }

  write(score);
}
