#!/usr/bin/env dub
/+ dub.sdl:
    name "d6p2"
+/

void shift(T)(T[] arr, T item)
{
  for (int i; i + 1 < arr.length; i++)
    arr[i] = arr[i + 1];

  arr[$ - 1] = item;
}

bool allDistinct(T)(T[] arr)
{
  for (int i; i < arr.length; i++)
    for (int j; j < arr.length; j++)
      if (i != j && arr[i] == arr[j])
        return false;
  
  return true;
}

void main()
{
  import std.stdio : write, writeln, stdin, chunks;

  char[4] lastFour;
  char[14] lastFourteen;
  int idx;
  bool second;

  foreach (ubyte[] line; chunks(stdin, 4096))
  foreach (char c; line)
  {
    idx++;

    shift(lastFour, c);
    shift(lastFourteen, c);

    if (second ? idx < lastFourteen.length : idx < lastFour.length)
      continue;

    if (!second && allDistinct(lastFour))
      second = true;
    else if (allDistinct(lastFourteen))
      break;
  }

  write(idx);
}
