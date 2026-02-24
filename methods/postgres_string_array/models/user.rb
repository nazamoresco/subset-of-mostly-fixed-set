# frozen_string_literal: true

class User < ApplicationRecord
  validates :favorite_colors, inclusion: { in: COLORS }, allow_blank: true
end
