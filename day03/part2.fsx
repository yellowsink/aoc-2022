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
|> Array.map set
|> Array.chunkBySize 3
|> Array.sumBy
    (function 
    | [|set1; set2; set3|] ->

      Set.intersect set1 set2
      |> Set.intersect set3
      |> Seq.exactlyOne
      |> priority
    
    | _ -> failwith "shut up f# compiler"
    )
|> printfn "%d"