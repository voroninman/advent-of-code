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
left_up = left .+ up
left_down = left .+ down
right_up = right .+ up
right_down = right .+ down
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

    if char == 'T'
        push!(state[to...], '#')
    end

    push!(state[to...], char)
    state
end

function move(state, direction)
    head = find(state, 'H')
    state = jump(state, 'H', head .+ direction)

    head = find(state, 'H')
    tail = find(state, 'T')
    distance = head .- tail

    if !is_close(distance)

        if direction == down && distance == down .+ right_down
            direction = direction .+ right
        elseif direction == down && distance == down .+ left_down
            direction = direction .+ left
        elseif direction == up && distance == up .+ right_up
            direction = direction .+ right
        elseif direction == up && distance == up .+ left_up
            direction = direction .+ left
        elseif direction == left && distance == left .+ left_down
            direction = direction .+ down
        elseif direction == left && distance == left .+ left_up
            direction = direction .+ up
        elseif direction == right && distance == right .+ right_down
            direction = direction .+ down
        elseif direction == right && distance == right .+ right_up
            direction = direction .+ up
        end

        state = jump(state, 'T', tail .+ direction)
    end
    state
end

state = to_matrix("""...\n...\n...""")
state[end,1] = ['.', '#', 'T', 'H']

function display_state(state)
    state .|>
        join .|>
        (x -> lpad(x, (state .|> length |> maximum) + 1, ' ')) |>
        eachrow .|>
        (x -> join(x, " ")) |>
        (x -> join(x, "\n")) |>
        (x -> (println(repeat('-', 80)); println(x)))
end

function top_char(chars)
    for char in "HT#."
        if char in chars
            return char
        end
    end
end

function display_state(state)
    state .|>
        (x -> top_char(x)) |>
        eachrow .|>
        (x -> join(x, " ")) |>
        (x -> join(x, "\n")) |>
        (x -> (println(repeat('-', 80)); println(x)))
end

for (cmd_dir, cmd_times) in parse_cmds("input.txt")
    for i in 1:cmd_times
        direction = cmd_mapping[cmd_dir]
        global state = move(state, direction)
        # display_state(state)
    end
end
println(state .|> (x -> '#' in x) |> sum)
