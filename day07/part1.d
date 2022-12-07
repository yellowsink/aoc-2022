#!/usr/bin/env dub
/+ dub.sdl:
    name "d7p1"
+/

class Node
{
  int filesize;
  bool isDir;
  Node[string] children;
  Node parent;

  @property size()
  {
    if (!isDir) return filesize;

    int s;
    foreach (child; children.byValue)
      s += child.size;
    
    return s;
  }
  
  this(int filesize = 0, bool isDir = false, Node[string] children = new Node[string], Node parentNode = null)
  {
    this.filesize = filesize;
    this.isDir = isDir;
    this.children = children;
    this.parent = parentNode;
  }
}

void main()
{
  import std.stdio : write, writeln, stdin, lines;

  auto root = new Node(0, true, new Node[string]);
  auto currentNode = root;
  bool areListing;

  void addChild(string name, int filesize = 0, bool isDir = false)
  {
    auto newNode = new Node(filesize, isDir, new Node[string], currentNode);
    currentNode.children[name] = newNode;
  }

  void cd(string name)
  {
    if (name == "/")
    {
      currentNode = root;
      return;
    }

    if (name == "..")
    {
      if (currentNode.parent is null)
        throw new Exception("cannot go up at root");
      
      currentNode = currentNode.parent;
      return;
    }
    
    if (!(name in currentNode.children))
      throw new Exception("cannot cd into non-existent dir");
    
    currentNode = currentNode.children[name];
  }

  foreach (string line; lines(stdin))
  {
    import std.string : stripRight;

    if (line[0] == '$') areListing = false;

    if (areListing)
    {
      if (line[0 .. 3] == "dir")
        addChild(line[4.. $-1].stripRight, 0, true);
      else
      {
        import std.string : split;
        import std.conv : to;
        auto splitted = line.split(" ");
        addChild(splitted[1].stripRight, splitted[0].to!int);
      }
    }
    else
    {
      auto isCd = line[2..4] == "cd";
      if (isCd)
      {
        auto dir = line[5 .. $-1].stripRight;
        cd(dir);
      }
      else areListing = true;
    }
  }

  int sum;
  auto thres = 100_000;

  void walk(Node n)
  {
    if (!n.isDir) return;

    if (n.size <= thres) sum += n.size;

    foreach (child; n.children.byValue)
      walk(child);
  }

  walk(root);

  write(sum);
}
