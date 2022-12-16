#!/usr/bin/env dub
/+ dub.sdl:
    name "d16p1"
+/

struct Valve
{
	int flowRate;
	int[string] edges;
	bool open;
}

T2[T] copySet(T, T2)(T2[T] s)
{
	T2[T] newSet;
	foreach (k, v; s)
		newSet[k] = v;

	return newSet;
}

string[][] routes(int cap, Valve[string] store, string start)
{
	string[][] results;

	void walk(string node, int minutesUsed, string[] wipPath, int toOpen, bool[string] treatOpen = new bool[string])
	{
			import std.stdio;
		if (toOpen == 0)
		{
			writeln(wipPath);
			results ~= wipPath;
			return;
		}

		foreach (edge, dist; store[node].edges)
		{
			auto isClosed = !(store[edge].open || edge in treatOpen);

			if (isClosed)
				treatOpen[edge] = true;

			auto thisStepMins = minutesUsed + dist + (store[edge].flowRate != 0 && isClosed);
			if (thisStepMins > cap)
				continue;

			walk(edge, thisStepMins, wipPath ~ edge, toOpen - isClosed, treatOpen.copySet());
		}
	}

	int amountToOpen;
	foreach (k, v; store)
	if (v.flowRate > 0)
		amountToOpen++;

	walk(start, 0, [start], amountToOpen);

	return results;
}

int pathFindTo(string from, string to, Valve[string] data)
{
	string[] current = [from];
	bool[string] visited;
	int steps;

	while (true)
	{
		assert(current.length > 0);

		bool found;
		foreach (c; current)
			if (c == to)
			{
				found = true;
				break;
			}
		if (found)
			break;

		string[] next;

		foreach (c; current)
			foreach (e; data[c].edges.byKey)
			{
				if (e in visited) continue;
				visited[e] = true;

				next ~= e;
			}

		current = next;

		steps++;
	}

	return steps;
}

void main()
{
	import std.stdio : write, writeln, stdin, lines;
	import std.string : stripRight, startsWith, split, join;
	import std.conv : to;
	import std.typecons : Tuple, tuple;
	import std.algorithm : min, max, maxElement;
	import std.regex : ctRegexImpl, matchFirst;

	Valve[string] valves;

	auto regex = ctRegexImpl!"Valve (..).*=(\\d+).*valves? (.*)".wrapper;

	foreach (string line; lines(stdin))
	{
		auto matched = matchFirst(line, regex);
		auto edges = matched[3].stripRight.split(", ");
		int[string] edgemap;

		foreach (e; edges)
			edgemap[e] = 1;

		valves[matched[1]] = Valve(
			matched[2].to!int,
			edgemap
		);
	}

	// populate distances
	foreach (k1; valves.byKey)
		foreach (k2; valves[k1].edges.byKey)
			valves[k1].edges[k2] = pathFindTo(k1, k2, valves);

	// remove 0 rate nodes
	foreach (key, value; valves)
		if (value.flowRate == 0)
		{
			foreach (k2, v2; valves)
			{
				if (!(k2 in value.edges))
				{
					foreach (edge, dist; value.edges)
					{
						if (edge in v2.edges)
						{}
						else
							v2.edges[edge]++;
						//else v2.edges[edge] = 1;
					}

					v2.edges.remove(key);
				}
			}

			if (key != "AA")
				valves.remove(key);
		}

	// fixup edges with self
	foreach (key, value; valves)
		value.edges.remove(key);

	writeln(valves);

	//auto paths = routes(30, valves, "AA");
	/* foreach (p; paths)
		//if (p.join().startsWith("AADDBBJJHHGGEECC"))
			writeln(p); */
	//write(paths.length);

}
