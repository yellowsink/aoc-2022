#!/usr/bin/env dub
/+ dub.sdl:
    name "d16p1"
+/

struct Valve
{
  int flowRate;
  string[] edges;
  bool open;
}

void main()
{
	import std.stdio : write, writeln, stdin, lines;
	import std.string : stripRight, startsWith, split;
	import std.conv : to;
	import std.typecons : Tuple, tuple;
	import std.algorithm : min, max, maxElement;
	import std.regex : ctRegexImpl, matchFirst;

  Valve[string] valves;

  auto regex = ctRegexImpl!"Valve (..).*=(\\d+).*valves? (.*)".wrapper;

	foreach (string line; lines(stdin))
	{
    auto matched = matchFirst(line, regex);
    valves[matched[1]] = Valve(
      matched[2].to!int,
      matched[3].stripRight.split(", ")
    );
	}

  // pressure released, nodes to close
  Tuple!(int, string[]) search(string from, string to)
  {
		if (from == to) return tuple(0, [from]);

    // bfs
    bool[string] visited;
    visited[from] = true;

    // flowrate, pressure, node id, path
    Tuple!(int, int, string, string[])[] paths = [
			tuple(0, 0, from, [from])
		];

    while (true)
    {
			Tuple!(int, int, string, string[])[] nextPaths;

			foreach (oldPath; paths)
				foreach (edge; valves[oldPath[2]].edges)
				{
					if (edge in visited) continue;
					visited[edge] = true;

					auto valve = valves[edge];
					auto flowRate = oldPath[0] + valve.flowRate;
					auto openTime = 1 + (!valve.open);
					auto path = tuple(flowRate, oldPath[1] + (flowRate * openTime), edge, oldPath[3] ~ edge);
					nextPaths ~= path;

					if (edge == to)
					{
						return tuple(path[1], path[3]);
					}
				}

			paths = nextPaths;
    }
  }

	int pressureReleased;

  auto node = "AA";
  for (int minute = 30; minute >= 0;)
  {
		writeln(node);
		Tuple!(int, string[])[] paths;
		foreach (edge; valves.byKey)
			paths ~= search(node, edge);

		writeln(paths);

		auto bestPath = paths.maxElement!(p => p[0])();

		foreach (n; bestPath[1])
		{
			if (!valves[n].open)
			{
				minute--;
				valves[n].open = true;
			}

			minute--;

			node = n;
		}

		pressureReleased += bestPath[0];
  }

	write(pressureReleased);
}
