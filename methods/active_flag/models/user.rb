# frozen_string_literal: true

class User < ApplicationRecord
  flag :favorite_colors, COLORS.map(&:to_sym)
end
