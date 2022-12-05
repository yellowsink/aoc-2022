#!/usr/bin/env dub
/+ dub.sdl:
    name "d5p1"
+/

import std.container : SList;

void moveCrate(SList!char[] stacks, int from, int to)
{
  stacks[to].insertFront(stacks[from].front);
  stacks[from].removeFront();
}

void main()
{
  import std.stdio : write, writeln, stdin, lines;
  import std.string : strip, split;
  import std.typecons : Nullable;

  bool inputtingMoves;
  string[] inputCrates = [];
  string[] inputMoves = [];

  foreach (string line; lines(stdin))
  {
    if (inputtingMoves)
      inputMoves ~= line.strip;
    else if (line.strip == "")
      inputtingMoves = true;
    else
      inputCrates ~= line.strip("\n");
  }
  
  SList!char[] stacks = new SList!char[inputCrates[$ - 1].split("   ").length];
  for (int i; i < stacks.length; i++)
    stacks[i] = SList!char();

  for (auto i = (cast(int) inputCrates.length) - 1; i >= 0; i--)
    for (int j; (j * 4 + 1) < inputCrates[i].length; j++)
    {
      auto c = inputCrates[i][j * 4 + 1];
      if (c != ' ')
        stacks[j].insertFront(c);
    }

  import std.regex : ctRegexImpl, matchFirst;
  
  auto regex = ctRegexImpl!("move (\\d+) from (\\d+) to (\\d+)").wrapper;

  foreach (rawMove; inputMoves)
  {
    import std.conv : to;
    auto match = matchFirst(rawMove, regex);

    auto amount = match[1].to!int;
    auto fromstack = match[2].to!int - 1;
    auto tostack = match[3].to!int - 1;

    for (int i; i < amount; i++)
      moveCrate(stacks, fromstack, tostack);
  }

  char[] res = [];
  foreach (stack; stacks)
    res ~= stack.front;

  write(res);
}
