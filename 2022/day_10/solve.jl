parse_ops(input) =
    input |>
    readlines .|> (
        line -> startswith(line, "addx")
                ? [0, parse(Int64, split(line)[2])]
                : [0]
    ) |>
    Iterators.flatten |> collect

function solve_1(input)
    ops = parse_ops(input)
    acc = accumulate(+, ops, init=1)
    (
        acc[-1+20] * 20
        + acc[-1+60] * 60
        + acc[-1+100] * 100
        + acc[-1+140] * 140
        + acc[-1+180] * 180
        + acc[-1+220] * 220
    )
end

function solve_2(input)
    ops = parse_ops(input)
    sprite = [1, 2, 3]
    for _ in 1:6
        for j in 1:40
            print(j in sprite ? '#' : '.')
            sprite = map(op -> sprite .+ op, popfirst!(ops))
        end
        print('\n')
    end
end

println(solve_1("input_test.txt"))
println(solve_1("input.txt"))

solve_2("input_test.txt")
solve_2("input.txt")
