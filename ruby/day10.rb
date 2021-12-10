# typed: strict
# frozen_string_literal: true

require 'set'
require_relative './aoc'

matching = {
  '}' => '{',
  ']' => '[',
  ')' => '(',
  '>' => '<'
}
opening = matching.values.to_set
closing = matching.keys.to_set

error_points_map = {
  ')' => 3,
  ']' => 57,
  '}' => 1_197,
  '>' => 25_137
}

incomplete_points_map = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
}

input = AOC.get_input(10).split("\n")

error_score = 0
incomplete_scores = []
input.each do |line|
  stack = []
  errored = T.let(false, T::Boolean)

  line.each_char do |c|
    case c
    when opening
      stack << c
    when closing
      expected = matching[c]
      if stack.pop != expected
        errored = true
        error_score += error_points_map[c]
        break
      end
    end
  end
  next if errored

  incomplete_scores << stack.reverse.reduce(0) do |acc, val|
    (acc * 5) + incomplete_points_map[val]
  end
end

puts "Part 1: #{error_score}"
puts "Part 2: #{incomplete_scores.sort[incomplete_scores.length / 2]}"
