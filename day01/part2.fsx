#!/usr/bin/env -S dotnet fsi --exec

open System
open System.IO

(new StreamReader(Console.OpenStandardInput())).ReadToEnd().Split("\n\n")
|> Array.map (fun s ->
    s.Split("\n", StringSplitOptions.RemoveEmptyEntries)
    |> Array.sumBy int
  )
|> Seq.sortDescending
|> Seq.take 3
|> Seq.sum
|> printfn "%d"