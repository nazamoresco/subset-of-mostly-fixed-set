# frozen_string_literal: true

class Color < ApplicationRecord
  has_many :user_colors, dependent: :destroy
  has_many :users, through: :user_colors

  validates :name, presence: true, uniqueness: true, inclusion: { in: COLORS }
end
