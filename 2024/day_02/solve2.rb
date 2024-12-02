def is_safe?(line)
  differences = line.each_cons(2).map { |a, b| b - a }.uniq
  differences.difference([1, 2, 3]).empty? || differences.difference([-1, -2, -3]).empty?
end

def variants(line)
  line.each_index.map do |i|
    line.dup.tap { |copy| copy.delete_at(i) }
  end
end

puts File
  .readlines('input.txt')
  .map(&:chomp)
  .map { |line| line.split.map(&:to_i) }
  .map { |line| variants(line).any? { |variant| is_safe?(variant) } }
  .count(true)
