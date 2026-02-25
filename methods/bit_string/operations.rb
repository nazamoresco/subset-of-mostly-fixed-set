# frozen_string_literal: true

module Operations
  def self.color_bits
    @color_bits ||= COLORS.each_with_index.each_with_object({}) { |(color, idx), h| h[color] = 1 << idx }
  end

  def self.create_user(colors)
    User.create!(favorite_colors: colors)
  end

  def self.find_by_color(color)
    color_bit = color_bits[color]
    bit_string = color_bit.to_s(2).rjust(12, '0')
    User.where("favorite_colors & B'#{bit_string}'::bit(12) <> B'000000000000'::bit(12)").to_a
  end

  def self.update_user_colors(user, colors)
    user.update!(favorite_colors: colors)
  end

  def self.count_by_color(color)
    color_bit = color_bits[color]
    bit_string = color_bit.to_s(2).rjust(12, '0')
    User.where("favorite_colors & B'#{bit_string}'::bit(12) <> B'000000000000'::bit(12)").count
  end
end
