#!/usr/bin/env dub
/+ dub.sdl:
    name "d11p1"
+/
module day11.part2;

class Monkey
{
  ulong[] items;
  int opAmount;
  bool opIsMul;
  int divTest;
  int trueTo;
  int falseTo;

  ulong inspectCount;
}

void main()
{
  import std.stdio : write, writeln, stdin, lines;
  import std.string : stripRight, startsWith, split;
  import std.conv : to;
  import std.regex : ctRegexImpl, matchFirst;
  import std.algorithm : partialSort;

  string input;

  foreach (string line; lines(stdin))
    input ~= line;

  Monkey[] monkeys = [];

  auto regex = ctRegexImpl!".*\n.*items: (.*)\n.*d (.) (.*)\n.* by (.*)\n.*key (.*)\n.*key (.*)"
    .wrapper;

  foreach (chunk; input.split("\n\n"))
  {
    auto match = matchFirst(chunk, regex);

    ulong[] items = [];
    foreach (item; match[1].split(", "))
      items ~= item.to!ulong;

    auto monkey = new Monkey();
    monkey.items = items;
    monkey.opAmount = match[3] == "old" ? -1 : match[3].to!int;
    monkey.opIsMul = match[2] == "*";
    monkey.divTest = match[4].to!int;
    monkey.trueTo = match[5].to!int;
    monkey.falseTo = match[6].to!int;

    monkeys ~= monkey;
  }

  int testBy = 1;
  foreach (monkey; monkeys)
    testBy *= monkey.divTest;

  for (int i; i < 10_000; i++)
  {
    foreach (monkey; monkeys)
    {
      foreach (item; monkey.items)
      {
        monkey.inspectCount++;
        ulong amt = monkey.opAmount == -1 ? item : monkey.opAmount;

        ulong newWorryLevel = (monkey.opIsMul ? item * amt : item + amt) % testBy;

        monkeys[
          (newWorryLevel % monkey.divTest == 0) ? monkey.trueTo: monkey.falseTo
        ].items ~= newWorryLevel;
      }

      monkey.items = [];
    }
  }

  partialSort!"a.inspectCount > b.inspectCount"(monkeys, 2);
  auto monkeyBusiness = monkeys[0].inspectCount * monkeys[1].inspectCount;
  write(monkeyBusiness);
}
