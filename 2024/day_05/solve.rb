require 'set'

rules, updates = File.read('input.txt').split("\n\n").map(&:lines)

rules = rules.map(&:chomp).map { |line| line.split('|') }
updates = updates.map(&:chomp).map { |line| line.split(',') }

rules_map = rules.each_with_object(Hash.new { |h, k| h[k] = [] }) do |(key, value), hash|
  hash[key] << value
  hash[key].sort!
end

correct, incorrect = updates.partition do |update|
  update.each_cons(2).all? do |pair|
    rules_map[pair[0]].include?(pair[1])
  end
end

ans1 = correct.sum do |o|
  o[o.length/2].to_i
end

puts ans1

ans2 = incorrect.map do |update|
  update_rules = rules.select { |rule| (rule & update).length == 2 }
  head = (update_rules.transpose[1] - update_rules.transpose[1]).first
  update.sort { |x, y| update_rules.include?([x, y]) ? -1 : 1 }
end.sum do |o|
  o[o.length/2].to_i
end

puts ans2
