# frozen_string_literal: true

class User < ApplicationRecord
  extend ArrayEnum

  COLORS = %w[red green blue yellow purple orange pink cyan magenta lime teal indigo]
  array_enum favorite_colors: COLORS.map.with_index { |color, index| [color, index] }.to_h
end
