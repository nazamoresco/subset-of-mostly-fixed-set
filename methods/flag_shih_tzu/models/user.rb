# frozen_string_literal: true

class User < ApplicationRecord
  include FlagShihTzu

  has_flags COLORS.each_with_index.map { |c, i| [i + 1, c.to_sym] }.to_h,
            column: 'favorite_colors'
end
