# typed: strict
# frozen_string_literal: true

require_relative './aoc'

extend T::Sig

sig { params(counts: T::Hash[Integer, Integer]).returns(T::Hash[Integer, Integer]) }
def advance(counts)
  res = {}
  counts.each do |n, count|
    if n.zero?
      res[6] = res.fetch(6, 0) + count
      res[8] = count
    else
      res[n - 1] = res.fetch(n - 1, 0) + count
    end
  end
  res
end

input = AOC.get_input(6).split(',').map(&:to_i)
counts = input.tally
80.times { counts = advance(counts) }
puts "Part 1: #{counts.values.sum}"

(256 - 80).times { counts = advance(counts) }
puts "Part 2: #{counts.values.sum}"
