ops = Dict("*" => *, "+" => +)
chunk(list, parts) = Iterators.partition(1:length(list), parts)

parse_block(lines) = string(lines[1][end-1]), Dict(
    :items => split(lines[2], ":")[2] |>
        (x -> split(x, ", ")) .|>
        x -> parse(Int, x),
    :f => split(lines[3])[end-1:end] |>
            (((op, rh),) -> (x -> ops[op](x, rh == "old" ? x : parse(Int, rh)))),
    :div => split(lines[4])[end] |>
        x -> parse(Int, x),
    :if_true => split(lines[5])[end],
    :if_false => split(lines[6])[end],
    :count => 0,
)

function solve(input; n, extra_f=x -> x)
    lines = readlines(input)
    monkeys = chunk(lines, 7) .|> (range -> parse_block(lines[range])) |> Dict
    common_div = reduce(*, [monkey[:div] for (_, monkey) in monkeys])

    for _ in 1:n
        for i in sort(collect(keys(monkeys)))
            monkey = monkeys[i]
            for item in monkey[:items]
                monkey[:count] += 1
                item = mod(extra_f(monkey[:f](item)), common_div)
                to = mod(item, monkey[:div]) == 0 ? monkey[:if_true] : monkey[:if_false]
                push!(monkeys[to][:items], item)
            end
            monkey[:items] = []
        end
    end
    monkeys |> keys .|> (x -> monkeys[x][:count]) |> sort |> (x -> x[end] * x[end-1])
end

println(solve("input_test.txt", n=20, extra_f=x -> floor(x / 3)))
println(solve("input.txt", n=20, extra_f=x -> floor(x / 3)))

println(solve("input_test.txt", n=10_000))
println(solve("input.txt", n=10_000))