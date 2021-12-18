# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require 'matrix'

# Helper methods for Advent of Code solutions
module AOC
  extend T::Sig

  sig { params(day: Integer).returns(String) }
  def self.get_input(day)
    File.read(File.expand_path("../input/day#{day}.txt", __dir__))
  end

  # Matrix doesn't work well with Sorbet
  sig { params(input: String).returns(T.untyped) }
  def self.digit_matrix(input)
    Matrix.rows(input.split("\n").map { _1.chars.map(&:to_i) })
  end
end
