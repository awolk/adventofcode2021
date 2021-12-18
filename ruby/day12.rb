# typed: strict
# frozen_string_literal: true

require_relative './aoc'
require 'set'

extend T::Sig

MAP = T.let(
  AOC.get_input(12).split("\n").map { |line| line.split('-') }
     .each_with_object({}) do |(a, b), h|
       (h[a] ||= []) << b unless b == 'start'
       (h[b] ||= []) << a unless a == 'start'
     end,
  T::Hash[String, T::Array[String]]
)

SMALL_CAVES = T.let(
  (MAP.keys - %w[start end]).select { |c| c == c.downcase }.to_set,
  T::Set[String]
)

sig { params(path: T::Array[String], double_small_cave_limit: Integer).returns(Integer) }
def paths(path: ['start'], double_small_cave_limit: 0)
  pos = T.must(path.last)
  return 1 if pos == 'end'

  double_small_cave_count = path.select { SMALL_CAVES.include?(_1) }.tally.count { |_, n| n == 2 }
  at_limit = double_small_cave_count >= double_small_cave_limit

  can_go = MAP.fetch(pos).reject do |pot|
    SMALL_CAVES.include?(pot) && path.count(pot) >= (at_limit ? 1 : 2)
  end
  can_go.sum { |p| paths(path: path + [p], double_small_cave_limit: double_small_cave_limit) }
end

puts "Part 1: #{paths}"
puts "Part 2: #{paths(double_small_cave_limit: 1)}"
