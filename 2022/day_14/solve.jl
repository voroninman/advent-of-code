function draw_walls(A, walls)
    for wall in walls
        for (a, b) in wall
            A[
                a[1] == b[1] ? a[1] : min(a[1], b[1]):max(a[1], b[1]),
                a[2] == b[2] ? a[2] : min(a[2], b[2]):max(a[2], b[2]),
            ] .= '#'
        end
    end
    A
end

convert(x) = (x[2] + 2, x[1] - 490)

down(A, x) = (
    findfirst(
        A[:, x[2]] .!= ' '
        .&&
        1:length(A[:, x[2]]) .> x[1]
        .||
        1:length(A[:, x[2]]) .== length(A[:, x[2]])
    ) - 1,
    x[2]
)
left_down(A, x) = (x[1] + 1, x[2] - 1)
right_down(A, x) = (x[1] + 1, x[2] + 1)
is_free(A, x) = A[x[1], x[2]] == ' '

function fall(A, x=convert((500, 0)))
    x = down(A, x)
    if x[2] < 2 || x[2] > length(A[1,:]) - 2
        return A, true
    end
    if is_free(A, left_down(A, x))
        return fall(A, left_down(A, x))
    elseif is_free(A, right_down(A, x))
        return fall(A, right_down(A, x))
    else
        A[x...] = 'o'
        if x == convert((500, 0))
            return A, true
        end
    end
    (A, false)
end


build_walls(input) = (
    input
    |> readlines
    .|> (x -> split(x, " -> ")
              .|> (x -> split(x, ",")
                        .|>
                        (x -> parse(Int, x)))
              .|> (x -> convert(x)))
    .|> x -> zip(x, x[2:end])
             .|>
             collect
)

max_ij(walls) = (
    walls
    .|> Iterators.flatten
    |> Iterators.flatten
    |> x -> reduce((x, y) -> (max(x[1], y[1]), max(x[2], y[2])), x)
)


function solve(input; with_floor=false)
    walls = build_walls(input)
    max_i, max_j = max_ij(walls)
    A = fill(' ', max_i * 5, max_j * 3)
    if with_floor
        A[end,:] .= '#'
    end
    A = draw_walls(A, walls)
    for i in 1:10_000
        A, last = fall(A)
        display(A)
        if last
            return i - 1
        end
    end
end

println(solve("input_test.txt"))
println(solve("input_test.txt", with_floor=true))

# A = A .|> x -> Dict(' ' => 255 / 255, '#' => 0 / 255, 'o' => 200 / 255)[x]

# using Images

# save("gray.png", colorview(Gray, A))


