# frozen_string_literal: true

class User < ApplicationRecord
  flag :favorite_colors, COLORS
end
