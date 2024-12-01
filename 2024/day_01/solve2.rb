input = File.readlines('input.txt').map(&:chomp)
lists = input.map { |line| line.split(' ').map(&:to_i) }.transpose
counts = lists.last.each_with_object(Hash.new(0)) { |num, counts| counts[num] += 1 }
puts lists.first.map { |num| num * counts[num] }.sum

