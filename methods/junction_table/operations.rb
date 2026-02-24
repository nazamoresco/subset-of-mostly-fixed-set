# frozen_string_literal: true

module Operations
  def self.create_user(colors)
    colors = Color.where(name: colors)
    user = User.create!(colors: colors)
    user
  end

  def self.find_by_color(color)
    color_record = Color.find_by!(name: color)
    color_record.users.to_a
  end

  def self.update_user_colors(user, colors)
    colors = Color.where(name: colors)
    user.colors.destroy_all
    user.colors << colors
    user.save!
  end

  def self.count_by_color(color)
    color_record = Color.find_by!(name: color)
    color_record.users.count
  end
end
