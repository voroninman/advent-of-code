require 'pp'
require 'set'

grid = File.readlines('input.txt').map(&:chomp).map { |line| line.chars }

def find_guard(grid)
  for i in 0..grid.length - 1
    for j in 0..grid.length - 1
      return [i, j] if "^><v".include?(grid[i][j])
    end
  end
end

class Array
  def dup
    Marshal.load(Marshal.dump(self))
  end
end

def step(grid)
  i, j = find_guard(grid)
  dir = grid[i][j]
  if grid[i][j] == '^'
    if i == 0
      return nil
    end
    if grid[i-1][j] == '.'
      return grid.dup.tap { |o| o[i-1][j] = o[i][j]; o[i][j] = '.' }
    else
      return grid.dup.tap { |o| o[i][j] = '>' }
    end
  end
  if grid[i][j] == '>'
    if j == grid[0].length - 1
      return nil
    end
    if grid[i][j+1] == '.'
      return grid.dup.tap { |o| o[i][j+1] = o[i][j]; o[i][j] = '.' }
    else
      return grid.dup.tap { |o| o[i][j] = 'v' }
    end
  end
  if grid[i][j] == 'v'
    if i == grid.length - 1
      return nil
    end
    if grid[i+1][j] == '.'
      return grid.dup.tap { |o| o[i+1][j] = o[i][j]; o[i][j] = '.' }
    else
      return grid.dup.tap { |o| o[i][j] = '<' }
    end
  end
  if grid[i][j] == '<'
    if j == 0
      return nil
    end
    if grid[i][j-1] == '.'
      return grid.dup.tap { |o| o[i][j-1] = o[i][j]; o[i][j] = '.' }
    else
      return grid.dup.tap { |o| o[i][j] = '^' }
    end
  end
end

visited = Set.new [find_guard(grid)]
while grid = step(grid)
  visited << find_guard(grid)
end
puts visited.length