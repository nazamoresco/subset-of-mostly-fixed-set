# frozen_string_literal: true

class User < ApplicationRecord
  COLOR_BITS = COLORS.each_with_index.each_with_object({}) { |(color, idx), h| h[color] = 1 << idx }

  validate :color_bits_are_valid, on: :create

  def favorite_colors=(colors)
    if colors.nil? || colors.empty?
      super('0')
    else
      bit_value = colors.sum(0) { |c| COLOR_BITS[c] || 0 }
      super(bit_value.to_s(2).rjust(12, '0'))
    end
  end

  def favorite_colors_list
    bits = read_attribute(:favorite_colors)
    return [] if bits.nil? || bits == '0'

    bits.chars.each_with_index.select { |b, _i| b == '1' }.map { |_b, i| COLORS[i] }
  end

  private

  def color_bits_are_valid
    return true if favorite_colors_list.empty?

    errors.add(:favorite_colors, 'contains invalid colors') unless favorite_colors_list.all? { |c| COLORS.include?(c) }
  end
end
