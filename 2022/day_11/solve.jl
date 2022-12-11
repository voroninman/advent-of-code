function parse_block(block)
    inventory = split(block[1], ":")[2] |> (x -> split(strip(x), ", ")) .|> (x -> parse(Int, x)) .|> (x -> convert(BigInt, x)) |> (x -> x)
    f = split(block[2], "=")[2] |>
        (x -> split(strip(x), " ")) |>
        (((lh, op, rh),) ->
            (x) -> (op == "*" ? ((a, b) -> a * b) : ((a, b) -> a + b))(
                x,
                rh == "old" ? x : parse(Int, rh)
            )
        )
    test = split(block[3], "by")[2] |>
           (x -> parse(Int, x)) |> (by -> (x) -> rem(x, by) == 0)
    if_true = split(block[4], " ")[end] |> x -> parse(Int, x)
    if_false = split(block[5], " ")[end] |> x -> parse(Int, x)
    inventory, f, test, if_true, if_false
end

function solve_1(input)
    lines = readlines(input)
    monkeys = lines |>
              x -> 1:(length(lines)+1)/7 .|>
                   (x -> convert(Int, x)) .|>
                   (x -> lines[(x-1)*7+2:(x-1)*7+6]) .|>
                   parse_block |>
                   x -> Dict(zip(0:length(x)-1, x))

    counts = [Set() for _ in 1:length(keys(monkeys))]

    for round in 1:20
        for monkey in 0:(length(keys(monkeys))-1)
            inventory, f, test, if_true, if_false = monkeys[monkey]
            for item in inventory
                push!(counts[monkey+1], item)
                new_item = f(item)
                if test(new_item)
                    push!(monkeys[if_true][1], new_item)
                else
                    push!(monkeys[if_false][1], new_item)
                end
            end
            monkeys[monkey] = [], monkeys[monkey][2:end]...
        end
        if round in [1, 20, 1_000, 2_000]
            println("ROUND: $round $(counts .|> length))")
        end
    end
end

solve_1("input_test.txt")
# println(solve_1("input.txt"))

# println(solve_2("input_test.txt"))
# println(solve_2("input.txt"))
