walk_ahead(list; size=0) =
    map(i -> list[i:i+size-1], range(1, length(list) - size - 1))

solve(input; size) = (
    read(input, String)
    |> (x -> walk_ahead(x, size=size))
    .|> Set
    .|> (x -> length(x) == size)
    |> findfirst
    |> (x -> x + size - 1)
)

println(solve("input_test.txt", size=4))
println(solve("input.txt", size=4))

println(solve("input_test.txt", size=14))
println(solve("input.txt", size=14))

