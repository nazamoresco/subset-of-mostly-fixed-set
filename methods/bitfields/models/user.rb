# frozen_string_literal: true

class User < ApplicationRecord
  include Bitfields
  bitfield :favorite_colors, *COLORS
end
