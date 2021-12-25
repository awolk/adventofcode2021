# typed: strict
# frozen_string_literal: true

require_relative './aoc'

extend T::Sig

module Packet
  extend T::Sig
  extend T::Helpers
  abstract!

  sig { abstract.returns(Integer) }
  def version_sum; end

  sig { abstract.returns(Integer) }
  def value; end
end

class Literal < T::Struct
  extend T::Sig
  include Packet
  const :version, Integer
  const :number, Integer

  sig { override.returns(Integer) }
  def version_sum
    version
  end

  sig { override.returns(Integer) }
  def value
    number
  end
end

class Operator < T::Struct
  extend T::Sig
  include Packet
  const :version, Integer
  const :type, Integer
  const :subpackets, T::Array[Packet]

  sig { override.returns(Integer) }
  def version_sum
    version + subpackets.sum(&:version_sum)
  end

  sig { override.returns(Integer) }
  def value
    evaluated = subpackets.map(&:value)
    case type
    when 0
      evaluated.sum
    when 1
      evaluated.reduce(&:*)
    when 2
      evaluated.min
    when 3
      evaluated.max
    when 5
      evaluated.fetch(0) > evaluated.fetch(1) ? 1 : 0
    when 6
      evaluated.fetch(0) < evaluated.fetch(1) ? 1 : 0
    when 7
      evaluated.fetch(0) == evaluated.fetch(1) ? 1 : 0
    else
      raise 'Unknown operator type'
    end
  end
end

sig { params(bits: T::Array[String], num: Integer).returns(Integer) }
def take_num!(bits, num)
  bits.shift(num).join.to_i(2)
end

sig { params(bits: T::Array[String]).returns(Packet) }
def take_packet!(bits)
  version = take_num!(bits, 3)
  type = take_num!(bits, 3)
  if type == 4
    number = 0
    while bits[0] == '1'
      bits.shift
      number = (number << 4) + take_num!(bits, 4)
    end
    bits.shift
    number = (number << 4) + take_num!(bits, 4)
    Literal.new(version: version, number: number)
  else
    length_type = bits.shift
    case length_type
    when '0'
      num_subpacket_bits = take_num!(bits, 15)
      subpacket_bits = bits.shift(num_subpacket_bits)
      subpackets = []
      subpackets << take_packet!(subpacket_bits) until subpacket_bits.empty?
    when '1'
      num_subpackets = take_num!(bits, 11)
      subpackets = num_subpackets.times.map do
        take_packet!(bits)
      end
    else
      raise "Unexpected length type '#{length_type}'"
    end
    Operator.new(version: version, type: type, subpackets: subpackets)
  end
end

bits = AOC.get_input(16).chars.flat_map do |c|
  c.to_i(16).to_s(2).rjust(4, '0').chars
end
packet = take_packet!(bits)
raise 'Unexpected padding' unless bits.all?('0')

puts "Part 1: #{packet.version_sum}"
puts "Part 2: #{packet.value}"
