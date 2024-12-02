puts File
  .readlines('input.txt')
  .map(&:chomp)
  .map { |line| line.split.map(&:to_i) }
  .map { |line| line.zip(line.drop(1))[0..-2].map { |pair| pair.reduce(:-) }.uniq }
  .map { |line| line.difference([1, 2, 3]).length == 0 || line.difference([-1, -2, -3]).length == 0 }
  .count(true)
