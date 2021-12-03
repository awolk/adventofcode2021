# typed: strict
# frozen_string_literal: true

require_relative './aoc'
require_relative './parser'

class Direction < T::Enum
  enums do
    Forward = new('forward')
    Down = new('down')
    Up = new('up')
  end
end

parse_direction = P.any(Direction.values.map(&:serialize)).map { Direction.deserialize(_1) }
parser = P.seq(parse_direction, ' ', P.int).each_line
input = T.let(parser.parse_all(AOC.get_input(2)), T::Array[[Direction, Integer]])

# Part 1
horizontal = 0
depth = 0
input.each do |dir, amount|
  case dir
  when Direction::Forward
    horizontal += amount
  when Direction::Down
    depth += amount
  when Direction::Up
    depth -= amount
  else
    T.absurd(dir)
  end
end

puts "Part 1: #{horizontal * depth}"

# Part 2
horizontal = 0
depth = 0
aim = 0
input.each do |dir, amount|
  case dir
  when Direction::Forward
    horizontal += amount
    depth += aim * amount
  when Direction::Down
    aim += amount
  when Direction::Up
    aim -= amount
  else
    T.absurd(dir)
  end
end

puts "Part 2: #{horizontal * depth}"
