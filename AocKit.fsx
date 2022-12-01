// AOCKIT - utils and tools for AOC in F# - by Yellowsink 2022

open System
open System.IO

module String =
  let split (sep: string) (s: string) = s.Split(sep, StringSplitOptions.RemoveEmptyEntries ||| StringSplitOptions.TrimEntries)

let input = (
    use sr = new StreamReader(Console.OpenStandardInput())
    sr.ReadToEnd()
  )

let inputLn = input |> (String.split "\n")
let inputCh = input |> (String.split "\n\n")
let inputChLn = inputCh |> Array.map (String.split "\n")
