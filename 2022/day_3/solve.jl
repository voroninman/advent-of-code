function split_in_half(x)
    half = floor(Int, length(x) / 2)
    [x[1:half], x[half+1:end]]
end

char_score(char) = Dict([Vector('a':'z'); Vector('A':'Z')] .=> 1:52)[char]

solve_1(input) = (
    input
    |> readlines
    .|> split_in_half
    .|> (x -> intersect(x...))
    .|> (x -> map(char_score, x))
    .|> sum
    |> sum
)

solve_2(input) = (
    input
    |> readlines
    |> (lines -> Iterators.partition(lines, 3))
    .|> (x -> intersect(x...))
    .|> (x -> map(char_score, x))
    .|> sum
    |> sum
)

println(solve_1("input_test.txt"))
println(solve_1("input.txt"))

println(solve_2("input_test.txt"))
println(solve_2("input.txt"))
