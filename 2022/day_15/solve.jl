parse_input(filename) = (
    filename
    |> readlines
    .|> x -> eachmatch(r"\-?\d+", x)
             .|> (x -> parse(Int, x.match))
             |> (((x1, y1, x2, y2),) -> ((y1, x1), (y2, x2)))
)

distance(a, b) = abs(a[1] - b[1]) + abs(a[2] - b[2])

overlap(S, d, i, points) = S[2]-d:S[2]+d |>
                           x -> filter(j -> distance((i, j), S) <= d && !((i, j) in points), x)
overlap(S, d, i, exclude) = (abs(S[1] - i) > d
                             ? []
                             : begin
    dy = abs(i - S[1])
    dx = d - dy
    (S[2] - dx, S[2] + dx)
end
)

solve_1(filename; target_row) = begin

    sensors = filename |>
              parse_input |>
              x -> map((((S, B),)) -> (S, B, distance(S, B)), x)

    target_row_points = sensors .|>
                        (x -> (x[1], x[2])) |>
                        Iterators.flatten |>
                        collect |>
                        x -> filter(point -> point[1] == target_row, x) |>
                             Set

    sensors .|>
    (((S, _, d),) -> overlap(S, d, target_row, target_row_points)) |>
    merge_ranges
    # Iterators.flatten |>
    # collect #|>
    # unique |>
    # length
end

function merge_ranges(ranges)
    filter!(x -> length(x) > 0, ranges)
    sort!(ranges, by=x -> x[1])

    max_ = ranges[1][2]
    for range in ranges[1:end]
        if range[1] == max_ + 2
            return max_ + 1
        end
        max_ = max(max_, range[2])
    end
    false
end

solve_2(filename) = begin
    for target_row in 0:4_000_000

        sensors = filename |>
                  parse_input |>
                  (x -> map((((S, B),)) -> (S, B, distance(S, B)), x)) |>
                  x -> filter(((S, B, d),) -> S[1] - d <= target_row <= S[1] + d, x)

        rv = sensors .|>
             (((S, _, d),) -> overlap(S, d, target_row, [])) |>
             merge_ranges
        if rv !== false
            println((target_row, rv), " ", target_row + rv * 4000000)
            break
        end

        if target_row % 100_000 == 0
            println("target_row = ", target_row)
        end

    end
end


a = [[], [1, 2, 3], [], [2, 3, 4], [6, 7], [7, 8]]
function merge_sets(list)
    v = [[]]
    for x in sort(list)
        if length(x) == 0
            continue
        end
        x = sort(x)
        if length(v[end]) == 0
            append!(v[end], x...)
            sort!(v[end])
            continue
        end
        if v[end][end] >= x[1]
            append!(v[end], x...)
            sort!(v[end])
            continue
        end
        push!(v, x)
    end
    v
end

# display(solve_1("input_test.txt", target_row=10))
# display(solve_1("input.txt", target_row=2000000))
#
display(solve_2("input_test.txt"))
display(solve_2("input.txt"))


# 2 033 888 508 472 is low