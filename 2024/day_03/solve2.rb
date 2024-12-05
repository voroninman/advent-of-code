require 'pp'

re = /mul\((\d{1,3}),(\d{1,3})\)/
ans = File.read('input.txt').chomp.scan(re).to_a.map do |pair|
  pair.map(&:to_i).reduce(:*)
end.sum

puts ans

