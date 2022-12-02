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

RPS parseRPS(bool isResp)(char c)
{
  return cast(RPS)(c - (isResp ? 'X' : 'A'));
}

int outcome(RPS theirs, RPS ours)
{
  if (theirs == ours)
    return 3;

  if ((theirs == RPS.Rock && ours == RPS.Paper)
    || (theirs == RPS.Paper && ours == RPS.Scissors)
    || (theirs == RPS.Scissors && ours == RPS.Rock))
    return 6;

  return 0;
}

void main()
{
  import std.stdio : write, stdin, lines;
  import std.conv : to;

  int score;

  foreach (string line; lines(stdin))
  {
    auto theirs = parseRPS!false(line[0]);
    auto ours = parseRPS!true(line[2]);

    score += outcome(theirs, ours) + 1 + ours;
  }

  write(score);
}
