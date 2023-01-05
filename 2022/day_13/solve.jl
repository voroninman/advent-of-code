parse_input(input) = readlines(input) .|> x -> eval(Meta.parse(x))
get_pairs(input) = parse_input(input) |> x -> 1:3:length(x)-1 .|> i -> (x[i], x[i+1])
isvector(x) = size(x) == (length(x),)

function is_correct(a, b)
    for i in 1:max(length(a), length(b))
        if i > length(b)
            return false
        elseif i > length(a)
            return true
        end

        a_, b_ = a[i], b[i]
        if (typeof(a[i]), typeof(b_)) == (Int, Int)
            if a_ != b_
                return a_ < b_
            end
        else
            if typeof(a_) == Int
                a_ = [a_]
            end
            if typeof(b_) == Int
                b_ = [b_]
            end

            found = is_correct(a_, b_)
            if found !== nothing
                return found
            end
        end
    end
end

solve_1(input) = (
    input
    |> get_pairs
    |> enumerate
    .|> (((i, x),) -> (i, x, is_correct(x...)))
    |> (x -> filter(((i, input, is_correct),) -> is_correct, x))
    .|> (((i, _, _),) -> i)
    |> sum)

solve_2(input) = (
    input
    |> parse_input
    |> (x -> filter(x -> x !== nothing, x))
    |> (x -> vcat(vcat(x, [[[2]]]), [[[6]]]))
    |> (x -> sort(x, lt=is_correct))
    |> enumerate
    .|> (((i, x),) -> x in [[[2]], [[6]]] ? i : 1)
    |> x -> reduce(*, x)
)

println(solve_1("input_test.txt"))
println(solve_1("input.txt"))

println(solve_2("input_test.txt"))
println(solve_2("input.txt"))