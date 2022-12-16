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

T2[T] copySet(T, T2)(T2[T] s)
{
	T2[T] newSet;
	foreach (k, v; s)
		newSet[k] = v;

	return newSet;
}

string[][] cappedRoutes(int cap, Valve[string] store, string start, bool[string] treatOpen = new bool[string])
{
	string[][] results;

	void walk(string node, int minutesUsed, string[] wipPath)
	{
		bool deadEnd = true;
		EDGES_LOOP: foreach (edge; store[node].edges)
		{
			foreach (n; wipPath)
				if (n == edge)
					continue EDGES_LOOP;

			deadEnd = false;

			auto thisStepMins = minutesUsed + 1 + (store[edge].flowRate != 0 && !(store[edge].open || edge in treatOpen));
			if (thisStepMins > cap)
				continue;

			walk(edge, thisStepMins, wipPath ~ edge);
		}

		if (deadEnd)
			results ~= wipPath;
	}

	walk(start, 0, [start]);

	return results;
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

	int bestFreed;

	void walk(int minutes, int pressureFreed, int flowRate, string currentNode, bool[string] visited)
	{
		foreach (route; cappedRoutes(minutes, valves, currentNode))
		{
			int pressureFreedThisRoute = pressureFreed;
			int flowRateThisRoute = flowRate;
			int minutesThisRoute;
			bool[string] openThisRoute = visited.copySet();

			foreach (node; route[1 .. $])
			{
				if (valves[node].flowRate != 0 && !(valves[node].open || node in openThisRoute))
				{
					openThisRoute[node] = true;
					minutesThisRoute++;
					pressureFreedThisRoute += flowRateThisRoute;
					flowRateThisRoute += valves[node].flowRate;
				}

				minutesThisRoute++;
				pressureFreedThisRoute += flowRateThisRoute;
			}

			foreach (key; route)
				openThisRoute[key] = true;

			if (minutesThisRoute >= minutes)
			{
				while (minutes > 0)
				{
					minutes--;
					pressureFreedThisRoute += flowRate;
				}

				if (pressureFreedThisRoute > bestFreed)
				{
					bestFreed = pressureFreedThisRoute;
					writeln("new best: ", pressureFreedThisRoute);
				}
			}
			else
				walk(minutes - minutesThisRoute,
					pressureFreedThisRoute,
					flowRateThisRoute,
					route[$ - 1],
					openThisRoute);
		}
	}

	bool[string] initialVisited;
	initialVisited["AA"] = true;
	walk(30, 0, 0, "AA", initialVisited);

	writeln(bestFreed);
}
