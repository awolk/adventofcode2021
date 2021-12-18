# typed: strict
# frozen_string_literal: true

require_relative './aoc'

extend T::Sig

sig { params(m: T.untyped, r: Integer, c: Integer).returns(T::Array[[Integer, Integer]]) }
def adjacent(m, r, c)
  rs = [0, r - 1].max..[m.row_size - 1, r + 1].min
  cs = ([0, c - 1].max..[m.column_size - 1, c + 1].min)
  rs.to_a.product(cs.to_a) - [[r, c]]
end

sig { params(m: T.untyped).returns(Integer) }
def advance!(m)
  flashes = 0
  m.map! { |i| i + 1 }
  while (r, c = m.index { |i| i > 9 })
    m[r, c] = 0
    flashes += 1

    adjacent(m, r, c).each do |ar, ac|
      m[ar, ac] += 1 unless m[ar, ac].zero?
    end
  end
  flashes
end

m = AOC.digit_matrix(AOC.get_input(11))

flashes = 100.times.sum { advance!(m) }
puts "Part 1: #{flashes}"

want = Matrix.zero(10, 10)
(100..).each do |step|
  if m == want
    puts "Part 2: #{step}"
    break
  end
  advance!(m)
end
