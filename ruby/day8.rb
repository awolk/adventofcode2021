# typed: strict
# frozen_string_literal: true

require_relative './aoc'

extend T::Sig

input = AOC.get_input(8).split("\n").map do |line|
  signals, outputs = line.split(' | ')
  [T.must(signals).split, T.must(outputs).split]
end

# Part 1
unique_lengths = [2, 4, 3, 7]
unique_length_output_count = input.sum do |_signals, outputs|
  outputs.count { unique_lengths.include?(_1.length) }
end
puts "Part 1: #{unique_length_output_count}"

# Part 2
CORRECT_MAPPING = T.let(
  {
    'cf' => 1,
    'acf' => 7,
    'bcdf' => 4,
    'abcdefg' => 8,

    'acdeg' => 2,
    'acdfg' => 3,
    'abdfg' => 5,

    'abcefg' => 0,
    'abdefg' => 6,
    'abcdfg' => 9
  }, T::Hash[String, Integer]
)

sig { params(signals: T::Array[String]).returns(T::Hash[String, String]) }
def find_mapping(signals)
  signals = signals.map(&:chars)

  cf = T.must(signals.find { _1.length == 2 })
  acf = T.must(signals.find { _1.length == 3 })
  bcdf = T.must(signals.find { _1.length == 4 })
  abcdefg = T.must(signals.find { _1.length == 7 })
  adg = signals.select { _1.length == 5 }.reduce(:&)
  abfg = signals.select { _1.length == 6 }.reduce(:&)

  bd = bcdf - cf
  a = acf - cf
  b = bd - adg
  f = abfg - adg - b
  c = cf - f
  d = bd - b
  e = abcdefg - abfg - bcdf
  g = adg - a - d

  { a[0] => 'a', b[0] => 'b', c[0] => 'c', d[0] => 'd', e[0] => 'e', f[0] => 'f', g[0] => 'g' }
end

sum_outputs = input.sum do |signals, outputs|
  mapping = find_mapping(signals)
  outputs.map do |output|
    mapped = output.chars.map(&mapping).sort.join
    CORRECT_MAPPING[mapped]
  end.join.to_i
end
puts "Part 2: #{sum_outputs}"
