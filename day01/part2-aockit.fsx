#!/usr/bin/env -S dotnet fsi --exec

#load "../AocKit.fsx"
open AocKit

inputChLn
|> Array.map (Array.sumBy int)
|> Seq.sortDescending
|> Seq.take 3
|> Seq.sum
|> printfn "%d"