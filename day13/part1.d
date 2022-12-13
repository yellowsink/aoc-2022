#!/usr/bin/env dub
/+ dub.sdl:
    name "d13p1"
+/

class Node
{
  int value;
  Node[] children;

  this(int v, Node[] c = [])
  {
    value = v;
    children = c;
  }
}

void main()
{
  import std.stdio : write, writeln, stdin, lines;
  import std.string : stripRight, startsWith, endsWith, split;
  import std.conv : to;
  import std.typecons : tuple, Tuple;

  Tuple!(Node, Node)[] chunks;

  Node working = new Node(-2);

  foreach (string line; lines(stdin))
  {
    if (line.stripRight == "") continue;

    import std.container : SList;

    auto root = new Node(-1);
    auto stack = SList!Node(root);

    foreach (c; line.stripRight[1..$-1].split(","))
    {
      while (c.startsWith("["))
      {
        auto n = new Node(-1);
        stack.front.children ~= n;
        stack.insertFront(n);

        c = c[1 .. $];
      }

      int dedent;
      while (c.endsWith("]"))
      {
        dedent++;
        c = c[0 .. $ - 1];
      }

      if (c.stripRight != "")
        stack.front.children ~= new Node(c.to!int);

      for (int i; i < dedent; i++)
        stack.removeFront();
    }

    if (working.value == -2)
      working = root;
    else
    {
      chunks ~= tuple(working, root);
      working = new Node(-2);
    }
  }

  int areSorted(Node a, Node b)
  {
    if (a.value >= 0 && b.value >= 0)
    {
      if (a.value == b.value)
        return -1;
      else
        return a.value < b.value;
    }

    if (a.value >= 0)
    {
      auto res = areSorted(new Node(-1, [a]), b);
      if (res != -1)
        return res;
    }
    
    if (b.value >= 0)
    {
      auto res = areSorted(a, new Node(-1, [b]));
      if (res != -1)
        return res;
    }

    for (int i; i < a.children.length && i < b.children.length; i++)
    {
      auto res = areSorted(a.children[i], b.children[i]);
      if (res != -1)
        return res;
    }

    if (a.children.length == b.children.length)
      return -1;

    return a.children.length < b.children.length;
  }

  int sum;
  for (int i; i < chunks.length; i++)
    if (areSorted(chunks[i][0], chunks[i][1]) == 1)
        sum += i + 1;
  
  write(sum);
}
