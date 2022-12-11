to_matrix(text) =
    text |>
    (x -> split(strip(x), "\n")) .|>
    collect |>
    vs -> reduce(vcat, permutedims.(collect.(vs))) .|>
    x -> x == '.' ? [x] : [x, '.']
parse_cmds(input) =
    input |> readlines .|> split .|> (((cmd, n),) -> (cmd, parse(Int, n)))
is_close(distance) = distance |> (((i, j),) -> -1 <= i <= 1 && -1 <= j <= 1)
left, right, up, down = (0, -1), (0, 1), (-1, 0), (1, 0)
cmd_mapping = Dict("U" => up, "R" => right, "D" => down, "L" => left)
find(state, char) = Tuple(findfirst(in.(char, state)))

function jump(state, char, to)
    state = filter.(x -> x != char, state)

    if to[1] == 0
        state = vcat(reshape([['.'] for _ in 1:size(state)[2]], 1, size(state)[2]), state)
        to = to[1] + 1, to[2]
    elseif to[2] == 0
        state = hcat(reshape([['.'] for _ in 1:size(state)[1]], size(state)[1], 1), state)
        to = to[1], to[2] + 1
    elseif to[1] > size(state)[1]
        state = vcat(state, reshape([['.'] for _ in 1:size(state)[2]], 1, size(state)[2]))
    elseif to[2] > size(state)[2]
        state = hcat(state, reshape([['.'] for _ in 1:size(state)[1]], size(state)[1], 1))
    end

    if char == '9'
        push!(state[to...], '#')
    end

    push!(state[to...], char)
    state
end

order = "H123456789"

function move(state, direction)
    head = find(state, 'H')
    state = jump(state, 'H', head .+ direction)

    for (head_char, tail_char) in zip(order, order[2:end])
        new_head = find(state, head_char)
        tail = find(state, tail_char)
        distance = new_head .- tail

        if !is_close(distance)
            direction = Dict(
                (-2, 1) => (-1, 1),
                (1, 2) => (1, 1),
                (0, 2) => (0, 1),
                (2, 2) => (1, 1),
                (-1, 2) => (-1, 1),
                (2, -1) => (1, -1),
                (-2, 2) => (-1, 1),
                (-2, -1) => (-1, -1),
                (1, -2) => (1, -1),
                (0, -2) => (0, -1),
                (2, 0) => (1, 0),
                (2, -2) => (1, -1),
                (-1, -2) => (-1, -1),
                (-2, 0) => (-1, 0),
                (2, 1) => (1, 1),
                (-2, -2) => (-1, -1),
            )[distance]

            state = jump(state, tail_char, tail .+ direction)
        end
    end
    state
end

state = to_matrix("""
...
...
H..
""")

state[end,1] = collect("H123456789#.")

for (cmd_dir, cmd_times) in parse_cmds("input.txt")
    for i in 1:cmd_times
        direction = cmd_mapping[cmd_dir]
        global state = move(state, direction)
    end
end
println(state .|> (x -> '#' in x) |> sum)

# 2418 is too low.