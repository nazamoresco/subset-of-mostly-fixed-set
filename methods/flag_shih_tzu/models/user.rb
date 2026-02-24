# frozen_string_literal: true

class User < ApplicationRecord
  include FlagShihTzu

  # Build flags hash from COLORS constant: {1 => :red, 2 => :green, ...}
  flags_hash = COLORS.each_with_object({}).with_index do |(color, hash), index|
    hash[index + 1] = color.to_sym
  end

  has_flags(
    flags_hash.merge(column: 'favorite_colors_flags')
  )
end
