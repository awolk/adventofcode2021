# typed: strict
# frozen_string_literal: true

require 'set'
require 'matrix'
require_relative './aoc'

extend T::Sig

matrix = Matrix.rows(AOC.get_input(9).split("\n").map { _1.chars.map(&:to_i) })

# Can't use Matrix with Sorbet because it's a Generic class but it defines []
sig { params(matrix: T.untyped, r: Integer, c: Integer).returns(T::Array[[Integer, Integer]]) }
def adjacent(matrix, r, c)
  [[r, c - 1], [r, c + 1], [r - 1, c], [r + 1, c]].select do |ar, ac|
    (0...matrix.row_size).include?(ar) && (0...matrix.column_size).include?(ac)
  end
end

low_points = matrix.each_with_index.filter_map do |height, r, c|
  [r, c] if adjacent(matrix, r, c).all? do |ar, ac|
    matrix[ar, ac] > height
  end
end

risk_level_sum = low_points.sum { |r, c| matrix[r, c] + 1 }
puts "Part 1: #{risk_level_sum}"

basin_sizes = low_points.map do |r, c|
  basin = Set[[r, c]]
  to_check = basin
  until to_check.empty?
    next_to_check = T.let(Set[], T::Set[[Integer, Integer]])
    to_check.each do |cr, cc|
      adjacent_to_check = adjacent(matrix, cr, cc).select do |ar, ac|
        adjacent_height = matrix[ar, ac]
        !basin.include?([ar, ac]) &&
          adjacent_height >= matrix[cr, cc] &&
          adjacent_height != 9
      end
      next_to_check.merge(adjacent_to_check)
    end
    basin.merge(next_to_check)
    to_check = next_to_check
  end
  basin.length
end

puts "Part 2: #{basin_sizes.max(3).reduce(&:*)}"
