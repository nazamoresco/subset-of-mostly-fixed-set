# frozen_string_literal: true

module Operations
  def self.create_user(colors)
    user = User.new
    user.favorite_colors = colors.map(&:to_sym)
    user.save!
    user
  end

  def self.find_by_color(color)
    User.where_favorite_colors(color.to_sym).to_a
  end

  def self.update_user_colors(user, colors)
    user.favorite_colors = colors.map(&:to_sym)
    user.save!
  end

  def self.count_by_color(color)
    User.where_favorite_colors(color.to_sym).count
  end
end
