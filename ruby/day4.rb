# typed: strict
# frozen_string_literal: true

require_relative './aoc'

class BingoBoard
  extend T::Sig

  sig { params(grid: T::Array[T::Array[Integer]]).void }
  def initialize(grid)
    @grid = grid
    @selected = T.let([], T::Array[Integer])
  end

  sig { params(str: String).returns(BingoBoard) }
  def self.parse(str)
    grid = str.split("\n").map do |line|
      line.strip.split.map(&:to_i)
    end
    new(grid)
  end

  sig { params(num: Integer).void }
  def mark(num)
    @selected << num
  end

  sig { returns(T::Boolean) }
  def won?
    @grid.each do |row|
      return true if row.all? { |n| @selected.include?(n) }
    end

    @grid.fetch(0).length.times do |c|
      col = @grid.map { |row| row[c] }
      return true if col.all? { |n| @selected.include?(n) }
    end

    false
  end

  sig { returns(T::Array[Integer]) }
  def unmarked
    @grid.flatten - @selected
  end
end

sections = AOC.get_input(4).split("\n\n")
numbers = T.must(sections.shift).split(',').map(&:to_i)
boards = sections.map { |str| BingoBoard.parse(str) }

first_win_score = T.let(nil, T.nilable(Integer))
last_win_score = T.let(nil, T.nilable(Integer))

numbers.each do |n|
  boards.dup.each do |board|
    board.mark(n)
    next unless board.won?

    score = board.unmarked.sum * n
    first_win_score = score if first_win_score.nil?
    last_win_score = score if boards.length == 1
    boards.delete(board)
  end
end

puts "Part 1: #{first_win_score}"
puts "Part 2: #{last_win_score}"
