parse_state(lines) = (
	lines[range(1,end-1)]
	.|> Iterators.enumerate
	.|> (x ->
        map(((position, char),)
            -> isletter(char) ? [convert(Int, (position - 2) / 4 + 1), char] : [], x))
	.|> (x -> filter(!isempty, x))
    |> Iterators.flatten
    |> (x -> foldl(
        (acc, x) ->
            haskey(acc, x[1])
            ? (append!(acc[x[1]], x[2]); return acc)
            : (acc[x[1]] = [x[2]]; return acc), x, init=Dict()
        )
    )
)

parse_actions(lines) = (
    lines
    |> (x -> filter(!isempty, x))
    .|> (x -> split(x, " "))
    .|> (x -> [x[2], x[4], x[6]])
    .|> (x -> parse.(Int, x))
)

parse_input(input_file) = (
    input_file
    |> readlines
    |> (x -> [
		collect(Iterators.takewhile(!isempty, x)),
		collect(Iterators.dropwhile(!isempty, x)),
	])
	|> (x -> [parse_state(x[1]), parse_actions(x[2])])
)

move(state, action; pick=x->x) = begin
    n, from, to = action
    left, took = state[from][n+1:end], pick(state[from][1:n])
    state[from] = left
    state[to] = vcat(took, state[to])
   state
end
move_pick_by_one(state, action) = move(state, action, pick=reverse)
move_pick_all(state, action) = move(state, action)

reduce_state(state) = join(map(x -> first(state[x]), sort(collect(keys(state)))))

solve_1(input) = (
	input
    |> parse_input
    |> ((state, actions),) -> foldl(move_pick_by_one, actions, init=state)
    |> reduce_state

)

solve_2(input) = (
	input
	|> parse_input
    |> (((state, actions),) -> foldl(move_pick_all, actions, init=state))
    |> reduce_state
)

println(solve_1("input_test.txt"))
println(solve_1("input.txt"))

println(solve_2("input_test.txt"))
println(solve_2("input.txt"))
