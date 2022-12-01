
function solve_1(input)
    max, acc = 0, 0

    for line = readlines(input)
        if isempty(line)
            if acc > max
                max = acc
            end
            acc = 0
            continue
        end

        acc += parse(Int64, line)
    end

    println("part 1: ", input, " ", max)
    max
end

function solve_2(input)
    acc, list = 0, []
    for line = readlines(input)
        if isempty(line)
            push!(list, acc)
            acc = 0
        else
            acc += parse(Int64, line)
        end
    end
    push!(list, acc)

    top_three_sum = sum(sort(list, rev=true)[1:3])
    println("part 2: ", input, " ", top_three_sum)
end

solve_1("input_test_1.txt")
solve_1("input_1.txt")

solve_2("input_test_1.txt")
solve_2("input_1.txt")

