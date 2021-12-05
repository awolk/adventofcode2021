# typed: strict
# frozen_string_literal: true

require_relative './aoc'
require_relative './parser'

extend T::Sig

class Line < T::Struct
  extend T::Sig
  const :x1, Integer
  const :y1, Integer
  const :x2, Integer
  const :y2, Integer

  sig { returns(T::Boolean) }
  def diagonal?
    x1 != x2 && y1 != y2
  end

  sig { returns(T::Array[[Integer, Integer]]) }
  def all_coords
    dx = x2 <=> x1
    dy = y2 <=> y1
    magnitude = [(x1 - x2).abs, (y1 - y2).abs].max
    (0..magnitude).map do |i|
      [x1 + (dx * i), y1 + (dy * i)]
    end
  end
end

sig { params(lines: T::Array[Line]).returns(Integer) }
def count_intersecting_coords(lines)
  counts = {}
  lines.each do |line|
    line.all_coords.each do |coord|
      counts[coord] = counts.fetch(coord, 0) + 1
    end
  end
  counts.values.count { |n| n > 1 }
end

parser = P.seq(P.int, ',', P.int, ' -> ', P.int, ',', P.int).map do |x1, y1, x2, y2|
  Line.new(x1: x1, y1: y1, x2: x2, y2: y2)
end.each_line

lines = T.let(parser.parse_all(AOC.get_input(5)), T::Array[Line])

puts "Part 1: #{count_intersecting_coords(lines.reject(&:diagonal?))}"
puts "Part 2: #{count_intersecting_coords(lines)}"
