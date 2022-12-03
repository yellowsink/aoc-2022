#!/usr/bin/env -S dotnet fsi --exec

#load "../AocKit.fsx"
open AocKit

let inline isUpper c = c.ToString().ToUpper() = c.ToString()

let inline priority c =
  if isUpper c then
    27 + (int c) - (int 'A')
  else
    1 + (int c) - (int 'a')

inputLn
|> Array.sumBy
    (fun line ->
      let half = line.Length / 2
      let firstHalf = set (Seq.take half line)
      let secondHalf = set (Seq.skip half line)

      Set.intersect firstHalf secondHalf
      |> Seq.exactlyOne
      |> priority
    )
|> printfn "%d"