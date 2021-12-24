# typed: strict
# frozen_string_literal: true

require 'set'
require_relative './aoc'

extend T::Sig

class PriorityQueue
  extend T::Sig
  extend T::Generic

  Elem = type_member

  sig { void }
  def initialize
    @array = T.let([], T::Array[[Elem, Integer]])
  end

  sig { params(value: Elem, priority: Integer).void }
  def add(value, priority)
    new_entry = [value, priority]
    index = @array.length
    @array << new_entry
    while index != 0
      parent_index = (index - 1) / 2
      parent = @array.fetch(parent_index)
      break if priority >= parent[1]

      @array[parent_index] = new_entry
      @array[index] = parent
      index = parent_index
    end
  end

  sig { returns(Elem) }
  def pop
    return T.must(@array.pop)[0] if @array.length == 1

    result = @array.fetch(0)[0]
    @array[0] = T.must(@array.pop)

    index = 0
    parent = @array.fetch(index)
    loop do
      c1_index = (index * 2) + 1
      c2_index = (index * 2) + 2
      c1 = @array[c1_index]
      c2 = @array[c2_index]
      break if (c1.nil? || parent[1] <= c1[1]) && (c2.nil? || parent[1] <= c2[1])

      swap_index =
        if c2.nil? || T.must(c1)[1] < c2[1]
          c1_index
        else
          c2_index
        end

      @array[index] = @array.fetch(swap_index)
      @array[swap_index] = parent
      index = swap_index
    end

    result
  end
end

class Graph
  extend T::Sig
  extend T::Helpers
  extend T::Generic
  abstract!

  Index = type_member

  sig { abstract.params(index: Index).returns(T::Array[[Index, Integer]]) }
  def adjacent(index); end

  sig { params(start: Index, finish: Index).returns(Integer) }
  def min_cost_between(start, finish)
    visited = T.let(Set[start], T::Set[Index])
    distances = T.let({ start => 0 }, T::Hash[Index, Integer])
    current = start
    to_visit = PriorityQueue[Index].new
    loop do
      break if current == finish

      current_dist = distances.fetch(current)
      adjacent(current).each do |pos, cost|
        next if visited.include?(pos)

        new_dist = current_dist + cost
        if !distances.key?(pos) || new_dist < distances.fetch(pos)
          distances[pos] = new_dist
          to_visit.add(pos, new_dist)
        end
      end

      visited << current
      current = to_visit.pop while visited.include?(current)
    end
    distances.fetch(finish)
  end
end

class CaveGraph < Graph
  Index = type_member(fixed: [Integer, Integer])

  sig { params(matrix: T.untyped).void }
  def initialize(matrix)
    super()
    @m = matrix
  end

  sig { override.params(index: Index).returns(T::Array[[Index, Integer]]) }
  def adjacent(index)
    r, c = index
    [[r, c - 1], [r, c + 1], [r - 1, c], [r + 1, c]].filter_map do |ar, ac|
      [[ar, ac], @m[ar, ac]] if
        (0...@m.row_size).include?(ar) && (0...@m.column_size).include?(ac)
    end
  end
end

# Part 1
m = AOC.digit_matrix(AOC.get_input(15))
pt1 = CaveGraph.new(m).min_cost_between([0, 0], [m.row_size - 1, m.column_size - 1])
puts "Part 1: #{pt1}"

# Part 2
row_matrices = (0...5).map do |row|
  col_matrices = (0...5).map do |col|
    m.map { |n| ((n + row + col - 1) % 9) + 1 }
  end
  Matrix.hstack(*T.unsafe(col_matrices))
end
m2 = Matrix.vstack(*T.unsafe(row_matrices))

pt2 = CaveGraph.new(m2).min_cost_between([0, 0], [m2.row_size - 1, m2.column_size - 1])
puts "Part 1: #{pt2}"

# 2602 is too low
# 3385 is too high
