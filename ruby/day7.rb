# typed: strict
# frozen_string_literal: true

require_relative './aoc'

input = AOC.get_input(7).split(',').map(&:to_i)

pt1 = (input.min..input.max).map do |pos|
  input.sum { |n| (n - pos).abs }
end.min
puts "Part 1: #{pt1}"

pt2 = (input.min..input.max).map do |pos|
  input.sum do |n|
    diff = (n - pos).abs
    diff * diff.next / 2
  end
end.min
puts "Part 2: #{pt2}"
