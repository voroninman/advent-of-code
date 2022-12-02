score(pair) =
    Dict(
        "A X" => 1 + 3,
        "A Y" => 2 + 6,
        "A Z" => 3 + 0,
        "B X" => 1 + 0,
        "B Y" => 2 + 3,
        "B Z" => 3 + 6,
        "C X" => 1 + 6,
        "C Y" => 2 + 0,
        "C Z" => 3 + 3,
    )[pair]

cheat(pair) =
    Dict(
        "A X" => 3 + 0,
        "A Y" => 1 + 3,
        "A Z" => 2 + 6,
        "B X" => 1 + 0,
        "B Y" => 2 + 3,
        "B Z" => 3 + 6,
        "C X" => 2 + 0,
        "C Y" => 3 + 3,
        "C Z" => 1 + 6,
    )[pair]

solve_1(input) = input |> readlines .|> score |> sum
solve_2(input) = input |> readlines .|> cheat |> sum

println(solve_1("input_test_1.txt"))
println(solve_1("input_1.txt"))

println(solve_2("input_test_1.txt"))
println(solve_2("input_1.txt"))
