# frozen_string_literal: true

class UserColor < ApplicationRecord
  belongs_to :user
  belongs_to :color

  validates :user_id, uniqueness: { scope: :color_id }
end
