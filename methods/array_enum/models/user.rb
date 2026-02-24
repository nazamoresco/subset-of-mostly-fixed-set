# frozen_string_literal: true

class User < ApplicationRecord
  extend ArrayEnum

  array_enum favorite_colors: COLORS.map.with_index { |color, index| [color, index] }.to_h
end
