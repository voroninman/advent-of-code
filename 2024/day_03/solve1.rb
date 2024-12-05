require 'pp'

re = /mul\((\d{1,3}),(\d{1,3})\)|(do(?:n't)?\(\))/
ans = File.read('input.txt').chomp.scan(re).to_a.reduce([0, true]) do |(sum, state), el|
  left, right, switch = el
  if !switch.nil?
    [sum, switch == "do()"]
  else
    [state ? sum+left.to_i*right.to_i : sum, state]
  end
end
PP.pp ans[0]
