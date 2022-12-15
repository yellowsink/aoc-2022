#!/usr/bin/env dub
/+ dub.sdl:
    name "d15p2"
+/

long manhattanDistance(long x1, long y1, long x2, long y2)
{
	import std.math : abs;

	return abs(x2 - x1) + abs(y2 - y1);
}

// x2, y2 = sensor loc
// x1, y1 = current loc
long amountToSkip(long x1, long y1, long x2, long y2, long distance)
{
	import std.math : abs;
	import std.algorithm : min, max;

	auto distanceAtY = distance - abs(y2-y1);
	return distanceAtY + x2 - x1;
}

void main()
{
	import std.stdio : write, writeln, stdin, lines;
	import std.string : stripRight, startsWith, split;
	import std.conv : to;
	import std.typecons : Tuple, tuple;
	import std.algorithm : min, max;
	import std.regex : ctRegexImpl, matchFirst;

	long minX = long.max;
	long minY = long.max;
	long maxX;
	long maxY;

	// x, y, closest beacon manhattan distance
	Tuple!(long, long, long)[] sensors;

	auto regex = ctRegexImpl!"x=(-?\\d+).*y=(-?\\d+).*x=(-?\\d+).*y=(-?\\d+)".wrapper;

	foreach (string line; lines(stdin))
	{
		auto matched = matchFirst(line, regex);
		auto x = matched[1].to!long;
		auto y = matched[2].to!long;
		auto distance = manhattanDistance(x, y, matched[3].to!long, matched[4].to!long);
		sensors ~= tuple(x, y, distance);

		minX = min(minX, x - distance);
		maxX = max(maxX, x + distance);
		minY = min(minY, y - distance);
		maxY = max(maxY, y + distance);
	}

	// clamp
	minX = max(minX, 0);
	minY = max(minY, 0);
	maxX = min(maxX, 4_000_000);
	maxY = min(maxY, 4_000_000);

	for (long y = minY; y <= maxY; y++)
	{
		for (long x = minX; x <= maxX;)
		{
			long maxSkip;
			foreach (sensor; sensors)
			{
				auto dist = manhattanDistance(sensor[0], sensor[1], x, y);
				if (dist <= sensor[2])
				{
					auto toSkip = amountToSkip(x, y, sensor[0], sensor[1], sensor[2]);
					maxSkip = max(maxSkip, toSkip);
				}
			}

			if (!maxSkip)
			{
				write(x * 4_000_000 + y);
				return;
			}

			x += maxSkip + 1;
		}
	}
}
