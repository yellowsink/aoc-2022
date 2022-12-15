#!/usr/bin/env dub
/+ dub.sdl:
    name "d15p1"
+/

int manhattanDistance(int x1, int y1, int x2, int y2)
{
	import std.math : abs;

	return abs((x2 - x1)) + abs((y2 - y1));
}

void main()
{
	import std.stdio : write, writeln, stdin, lines;
	import std.string : stripRight, startsWith, split;
	import std.conv : to;
	import std.typecons : Tuple, tuple;
	import std.algorithm : min, max;
	import std.regex : ctRegexImpl, matchFirst;

	int minX = int.max;
	int maxX;

	// x, y, closest beacon manhattan distance
	Tuple!(int, int, int)[] sensors;

	auto regex = ctRegexImpl!"x=(-?\\d+).*y=(-?\\d+).*x=(-?\\d+).*y=(-?\\d+)".wrapper;

	foreach (string line; lines(stdin))
	{
		auto matched = matchFirst(line, regex);
		auto x = matched[1].to!int;
		auto y = matched[2].to!int;
		auto distance = manhattanDistance(x, y, matched[3].to!int, matched[4].to!int);
		sensors ~= tuple(x, y, distance);

		minX = min(minX, x - distance);
		maxX = max(maxX, x + distance);
	}

	auto testY = 2_000_000;

	int numCovered;
	for (auto i = minX; i <= maxX; i++)
		foreach (sensor; sensors)
			if (manhattanDistance(sensor[0], sensor[1], i, testY) <= sensor[2])
			{
				numCovered++;
				break;
			}

	write(numCovered - 1);
}
