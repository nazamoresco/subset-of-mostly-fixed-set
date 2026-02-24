# frozen_string_literal: true

module Operations
  def self.create_user(colors)
    user = User.new
    colors.each { |color| user.favorite_colors.set(color) }
    user.save!
    user
  end

  def self.find_by_color(color)
    User.favorite_colors(color).to_a
  end

  def self.update_user_colors(user, colors)
    # Clear all flags first
    COLORS.each { |color| user.favorite_colors.unset(color) }
    
    # Set new flags
    colors.each { |color| user.favorite_colors.set(color) }
    
    user.save!
  end

  def self.count_by_color(color)
    User.favorite_colors(color).count
  end
end
