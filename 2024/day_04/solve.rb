require 'pp'

input = File.readlines('input.txt').map(&:chomp)

dia1, dia2 = [], []
input.each_with_index do |line, i|
  dia1.push(line.dup.prepend(' ' * i).concat(' ' * (line.length - i)))
  dia2.push(line.dup.prepend(' ' * (line.length - i)).concat(' ' * i))
end

def rotate(lines)
  lines.map(&:chars).transpose.map(&:join)
end

def xmas_count(lines)
  lines.map do |line| 
    line.scan("XMAS").size + line.scan("SAMX").size
  end.sum
end

puts [input, rotate(input), rotate(dia1), rotate(dia2)].map { |lines| xmas_count(lines) }.sum

input.map.with_index do |line, i|
  next if i == 0 or i == input.length - 1
  line.chars.map.with_index do |c, j|
    next if j == 0 or j == line.length - 1
    next if c != 'A'
    if [input[i-1][j-1], input[i+1][j+1]].sort == ["M", "S"] && [input[i-1][j+1], input[i+1][j-1]].sort == ["M", "S"]
      1
    end
  end.compact.sum
end.compact.sum.tap { |ans| puts ans }
