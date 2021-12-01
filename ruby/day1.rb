# typed: strict
# frozen_string_literal: true

require_relative './aoc'

input = AOC.get_input(1).split("\n").map(&:to_i)
pt1 = input.each_cons(2).count { T.must(_2) > T.must(_1) }
puts "Part 1: #{pt1}"
pt2 = input.each_cons(3).map(&:sum).each_cons(2).count { T.must(_2) > T.must(_1) }
puts "Part 2: #{pt2}"
