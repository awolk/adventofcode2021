# typed: strict
# frozen_string_literal: true

require_relative './aoc'
require_relative './parser'

extend T::Sig

parser = P.seq(P.word, "\n\n", P.seq(P.word, ' -> ', P.word).each_line.map(&:to_h))
start, rules = T.let(
  parser.parse_all(AOC.get_input(14)),
  [String, T::Hash[String, String]]
)

sig do
  params(pair_counts: T::Hash[String, Integer], rules: T::Hash[String, String])
    .returns(T::Hash[String, Integer])
end
def new_pair_counts(pair_counts, rules)
  pair_counts.each_with_object({}) do |(pair, count), new_counts|
    new_mid = rules.fetch(pair)
    pair_a = T.must(pair[0]) + new_mid
    pair_b = new_mid + T.must(pair[1])
    new_counts[pair_a] = new_counts.fetch(pair_a, 0) + count
    new_counts[pair_b] = new_counts.fetch(pair_b, 0) + count
  end
end

sig { params(pair_counts: T::Hash[String, Integer]).returns(Integer) }
def element_count_diffs(pair_counts)
  element_counts = pair_counts.each_with_object({}) do |(pair, count), counts|
    counts[pair[0]] = counts.fetch(pair[0], 0) + count
    counts[pair[1]] = counts.fetch(pair[1], 0) + count
  end
  min_count, max_count = element_counts.values.minmax
  (max_count / 2.0).ceil - (min_count / 2.0).ceil
end

pair_counts = start.chars.each_cons(2).map(&:join).tally
10.times { pair_counts = new_pair_counts(pair_counts, rules) }
puts "Part 1: #{element_count_diffs(pair_counts)}"

30.times { pair_counts = new_pair_counts(pair_counts, rules) }
puts "Part 2: #{element_count_diffs(pair_counts)}"
