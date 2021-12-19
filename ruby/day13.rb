# typed: strict
# frozen_string_literal: true

require 'set'
require_relative './aoc'
require_relative './parser'

extend T::Sig

coord = P.seq(P.int, ',', P.int)
x_or_y = P.any(%w[x y])
fold = P.seq('fold along ', x_or_y, '=', P.int)
parser = P.seq(coord.each_line.map(&:to_set), "\n\n", fold.each_line)
dots, folds = T.let(
  parser.parse_all(AOC.get_input(13)),
  [T::Set[[Integer, Integer]], T::Array[[String, Integer]]]
)

sig do
  params(dots: T::Set[[Integer, Integer]], axis: String, pos: Integer)
    .returns(T::Set[[Integer, Integer]])
end
def perform_fold(dots, axis, pos)
  dots.map do |x, y|
    case axis
    when 'x'
      if x < pos
        [x, y]
      else
        [pos - (x - pos), y]
      end
    when 'y'
      if y < pos
        [x, y]
      else
        [x, pos - (y - pos)]
      end
    end
  end.to_set
end

# Part 1
ff_axis, ff_pos = T.must(folds.first)
after_1_fold = perform_fold(dots, ff_axis, ff_pos).size
puts "Part 1: #{after_1_fold}"

# Part 2
final_image = folds.reduce(dots) { |i, (axis, pos)| perform_fold(i, axis, pos) }
max_x = final_image.map(&:first).max
max_y = final_image.map(&:last).max
puts 'Part 2:'
(0..max_y).each do |y|
  puts (0..max_x).map { |x| final_image.include?([x, y]) ? '#' : ' ' }.join
end
