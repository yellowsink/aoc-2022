#!/usr/bin/env dub
/+ dub.sdl:
    name "d11p1"
+/

class Monkey
{
  int[] items;
  int opAmount;
  bool opIsMul;
  int divTest;
  int trueTo;
  int falseTo;
  
  int inspectCount;
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

  auto regex = ctRegexImpl!".*\n.*items: (.*)\n.*d (.) (.*)\n.* by (.*)\n.*key (.*)\n.*key (.*)".wrapper;

  foreach (chunk; input.split("\n\n"))
  {
    auto match = matchFirst(chunk, regex);

    int[] items = [];
    foreach (item; match[1].split(", "))
      items ~= item.to!int;

    auto monkey = new Monkey();
    monkey.items = items;
    monkey.opAmount = match[3] == "old" ?  - 1 : match[3].to!int;
    monkey.opIsMul = match[2] == "*";
    monkey.divTest = match[4].to!int;
    monkey.trueTo = match[5].to!int;
    monkey.falseTo = match[6].to!int;
    
    monkeys ~= monkey;
  }

  for (int i; i < 20; i++)
    foreach (monkey; monkeys)
    {
      foreach (item; monkey.items)
      {
        monkey.inspectCount++;
        auto amt = monkey.opAmount == -1 ? item : monkey.opAmount;

        int newWorryLevel =
          (monkey.opIsMul ? item * amt : item + amt) / 3;
        
        monkeys[
          (newWorryLevel % monkey.divTest == 0) ? monkey.trueTo : monkey.falseTo
        ].items ~= newWorryLevel;
      }

      monkey.items = [];
    }
  
  foreach (monkey; monkeys)
  {
    writeln(monkey.inspectCount);
  }
  
  partialSort!"a.inspectCount > b.inspectCount"(monkeys, 2);
  auto monkeyBusiness = monkeys[0].inspectCount * monkeys[1].inspectCount;
  write(monkeyBusiness);
}
