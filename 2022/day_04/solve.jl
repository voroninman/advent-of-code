function is_include(abcd)
    a, b, c, d = abcd
    a <= c && d <= b || c <= a && b <= d || a == c || b == d
end

function is_overlap(abcd)
    a, b, c, d = abcd
    c >= a && c <= b || a >= c && a <= d
end

parse_pairs(line) = (
    split(line, ',')
    .|> (x -> split(x, '-') .|> (x -> parse(Int, x)))
    |> Iterators.flatten
    |> collect
)

solve_1(input) = input |> readlines .|> parse_pairs .|> is_include |> sum
solve_2(input) = input |> readlines .|> parse_pairs .|> is_overlap |> sum

println(solve_1("input_test.txt"))
println(solve_1("input.txt"))

println(solve_2("input_test.txt"))
println(solve_2("input.txt"))
