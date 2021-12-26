# typed: strict
# frozen_string_literal: true

require_relative './aoc'
require_relative './parser'

parser = P.seq('target area: x=', P.int, '..', P.int, ', y=', P.int, '..', P.int)
xa, xb, ya, yb = T.let(
  parser.parse_all(AOC.get_input(17)),
  [Integer, Integer, Integer, Integer]
)

# y range is fairly arbitrary for brute force solution
best_ys = (0..xb).to_a.product((-1000..500).to_a).filter_map do |dx, dy|
  hit_target = T.let(false, T::Boolean)
  max_y = 0
  x = 0
  y = 0
  until x > xb || y < ya
    x += dx
    y += dy
    dx -= 1 if dx.positive?
    dy -= 1
    max_y = y if y > max_y
    hit_target = true if (xa..xb).include?(x) && (ya..yb).include?(y)
  end
  max_y if hit_target
end

puts "Part 1: #{best_ys.max}"
puts "Part 2: #{best_ys.length}"
