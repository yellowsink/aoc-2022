#!/usr/bin/env dub
/+ dub.sdl:
    name "d13p2"
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
  import std.algorithm : sort;

  Node[] nodes = [
    // divider packets
    new Node(-1, [new Node(2)]),
    new Node(-1, [new Node(6)]),
  ];

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

    nodes ~= root;
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

  import std.algorithm : swap;

  // bubble sort should work fine
  bool didSort;
  while (true)
  {
    didSort = false;
    for (int i; i + 1 < nodes.length; i++)
    {
      if (areSorted(nodes[i], nodes[i + 1]) == 0)
      {
        swap(nodes[i], nodes[i + 1]);
        didSort = true;
      }
    }

    if (!didSort)
      break;
  }
  
  int i1;
  int i2;

  for (int i; i < nodes.length; i++)
  {
    if (nodes[i].value == -1 && nodes[i].children.length == 1)
    {
      if (nodes[i].children[0].value == 2)
        i1 = i;
      else if (nodes[i].children[0].value == 6)
        i2 = i;
    }
  }

  write((i1 + 1) * (i2 + 1));
}
