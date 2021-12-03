# typed: strict
# frozen_string_literal: true

require_relative './aoc'

extend T::Sig

input = AOC.get_input(3).split("\n")

# prefer 1 to 0
sig { params(bits: T::Array[String]).returns(String) }
def most_common_bit(bits)
  T.must((bits + %w[0 1]).tally.max_by {[_2, _1]}).first
end

# prefer 0 to 1
sig { params(bits: T::Array[String]).returns(String) }
def least_common_bit(bits)
  T.must((bits + %w[0 1]).tally.min_by {[_2, _1]}).first
end

## Part 1
gamma = 0
epsilon = 0

(0...input.fetch(0).length).each do |i|
  bits = input.map { |line| T.must(line[i]) }
  gamma = (gamma << 1) + most_common_bit(bits).to_i
  epsilon = (epsilon << 1) + least_common_bit(bits).to_i
end

power_consumption = gamma * epsilon
puts "Part 1: #{power_consumption}"

## Part 2
sig do
  params(
    list: T::Array[String],
    blk: T.proc.params(bits: T::Array[String]).returns(String)
  ).returns(String)
end
def filter_by_bit_criteria(list, &blk)
  index = 0
  until list.length == 1
    values_at_index = list.map { |row| T.must(row[index]) }
    keep_bit = blk.call(values_at_index)
    list = list.select { |row| row[index] == keep_bit }
    index += 1
  end
  list.fetch(0)
end

oxygen = filter_by_bit_criteria(input) { |bits| most_common_bit(bits) }.to_i(2)
co2 = filter_by_bit_criteria(input) { |bits| least_common_bit(bits) }.to_i(2)
life_support = oxygen * co2
puts "Part 2: #{life_support}"
