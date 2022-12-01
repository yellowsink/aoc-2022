#!/usr/bin/env -S dotnet fsi --exec

#load "../AocKit.fsx"
open AocKit

inputChLn
|> Array.map (Array.sumBy int)
|> Array.max
|> printfn "%d"