# frozen_string_literal: true

module Operations
  def self.create_user(colors)
    User.create!(favorite_colors: colors)
  end

  def self.find_by_color(color)
    User.with_favorite_colors(color).to_a
  end

  def self.update_user_colors(user, colors)
    user.update!(favorite_colors: colors)
  end

  def self.count_by_color(color)
    User.with_favorite_colors(color).count
  end
end
