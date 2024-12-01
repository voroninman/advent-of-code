input = File.readlines('input.txt').map(&:chomp)
lists = input.map { |line| line.split(' ').map(&:to_i) }.transpose
puts lists.map(&:sort).transpose.map { |a, b| (b - a).abs }.sum