function build_edges(A, start, target)
    I, J = length(A), length(A[1])
    start, target = nothing, nothing
    edges = Dict()
    as = []
    for i in 1:I
        for j in 1:J
            edges[(i, j)] = []

            if A[i][j] == 28
                target = (i, j)
            end
            if A[i][j] == 1
                start = (i, j)
            end

            if A[i][j] == 2
                push!(as, (i, j))
            end

            if j > 1 && A[i][j-1] - A[i][j] <= 1
                push!(edges[(i, j)], (i, j - 1))
            end
            if i > 1 && A[i-1][j] - A[i][j] <= 1
                push!(edges[(i, j)], (i - 1, j))
            end
            if j < J && A[i][j+1] - A[i][j] <= 1
                push!(edges[(i, j)], (i, j + 1))
            end
            if i < I && A[i+1][j] - A[i][j] <= 1
                push!(edges[(i, j)], (i + 1, j))
            end
        end
    end
    edges, start, target, as
end

function walk(edges, start, target)
    queue = [(start, 0)]
    visited = Set()
    while length(queue) > 0
        (node, cost) = popfirst!(queue)
        if node == target
            return cost
        end
        if node in visited
            continue
        end
        push!(visited, node)
        for neighbor in edges[node]
            push!(queue, (neighbor, cost + 1))
        end
    end
end

function solve_2(input)
    A = read(input, String) |>
            (x -> replace(x, "S" => "`", "E" => "{")) |>
            (x -> split(strip(x), "\n") .|> collect) .|>
            x -> map(char -> Int(char) - 95, x)

    edges, as = build_edges(A)
    xs = as .|> (x -> walk(edges, x, target))
    xs[xs.!==nothing] |> minimum
end

display(solve_2("input.txt"))
# println(solve_1("input.txt"))