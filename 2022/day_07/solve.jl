function parse_state(input)
    function update(state, path, size)
        for sub_path in [path[1:i] for i in 0:length(path)]
            state[sub_path] = size + get(state,sub_path, 0)
        end
        state
    end

    lines = readlines(input)
    lines = filter(x -> x ∉ ["\$ cd /", "\$ ls"] && !startswith(x, "dir"), lines)
    cwd, state = [], Dict()
    for line in lines
        if startswith(line, "\$ cd")
            _, _, dir = split(line)
            if dir == ".."
                pop!(cwd)
            else
                push!(cwd, dir)
            end
            continue
        end
        size = parse(Int, split(line)[1])
        state = update(state, cwd, size)
    end
    state
end

solve_1(input) =
    parse_state(input) |> values |> collect |> (x -> filter(y -> y < 100000, x)) |> sum

solve_2(input) = begin
    state = parse_state(input)
    total_sum = state[[]]
    required = abs(70000000 - 30000000 - total_sum)
    state |>
        values |>
        collect |>
        sort |>
        (x -> filter(y -> y >= required, x)) |>
        first
end

println(solve_1("input_test.txt"))
println(solve_1("input.txt"))

println(solve_2("input_test.txt"))
println(solve_2("input.txt"))