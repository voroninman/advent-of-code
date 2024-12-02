require "pp"

def is_safe(line)
  x = line.zip(line.drop(1))[0..-2].map { |pair| pair.reduce(:-) }.uniq
  x.difference([1, 2, 3]).length == 0 || x.difference([-1, -2, -3]).length == 0
end

def variants(line)
  [line] + (0..line.length - 1).map do |i|
    copy = line.dup
    copy.delete_at(i)
    copy
  end
end

puts(
  File
    .readlines("input.txt")
    .map(&:chomp)
    .map { |line| line.split.map(&:to_i) }
    .map
) do |line|
  variants(line).map do |v|
    if is_safe(v)
      break true
    end

    false
  end
end
  .flatten
  .count(true)
