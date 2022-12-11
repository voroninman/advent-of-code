to_matrix(vs) = reduce(vcat, transpose.(vs))
apply_repeat(f, n, x) = foldl((acc, _) -> f(acc), 1:n, init=x)
apply_rotated(f, n, x) =
    apply_repeat(rotr90, n, x) |> (x -> f(x)) |> (x -> apply_repeat(rotl90, n, x))

function parse_matrix(input)
    input |>
    readlines .|>
    collect .|>
    (x -> parse.(Int, x)) |>
    to_matrix
end

function left_to_right_visibility(a::Matrix{Int})
    function left_to_right_visibility(row::Vector{Int})
        left_to_right_acc_max(row) = accumulate(max, vcat([0], row[1:end-1]))
        pair_with_acc_max = zip(row, left_to_right_acc_max(row))
        map(((x, acc_max),) -> x > acc_max, pair_with_acc_max)
    end

    a |>
    eachrow .|>
    collect .|>
    left_to_right_visibility |>
    to_matrix
end

function perimeter_matrix(n)
    a = zeros(n, n)
    a[1, :] .= 1
    a[end, :] .= 1
    a[:, 1] .= 1
    a[:, end] .= 1
    a .== 1
end

function left_to_right_count_visible(A)
    count(height, trees) = (
        findfirst(trees .>= height) === nothing
        ? length(trees)
        : findfirst(trees .>= height)
    )

    A |>
    eachrow .|>
    (row -> map(((i, x),) -> [row[i], row[i+1:end]], enumerate(row[1:end-1]))) .|>
    (x -> map(x -> count(x...), x)) .|>
    (x -> vcat(x, [0])) |>
    to_matrix
end

function solve_1(input)
    A = parse_matrix(input)
    foldl(
        (acc, i) -> acc .|| apply_rotated(left_to_right_visibility, i, A),
        0:3,
        init=perimeter_matrix(size(A)[1])
    ) |> sum
end

function solve_2(input)
    A = parse_matrix(input)
    foldl(
        (acc, i) -> acc .* apply_rotated(left_to_right_count_visible, i, A),
        0:3,
        init=ones(size(A)...)
    ) |>
    maximum |>
    x -> round(Int, x)
end

display(solve_1("input_test.txt"))
println(solve_1("input.txt"))

display(solve_2("input_test.txt"))
println(solve_2("input.txt"))