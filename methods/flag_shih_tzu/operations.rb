# frozen_string_literal: true

module Operations
  def self.create_user(colors)
    user = ::User.new
    COLORS.each { |color| user.send("#{color}=", false) }
    colors.each { |color| user.send("#{color}=", true) }
    user.save!
    user
  end

  def self.find_by_color(color)
    ::User.send(color).to_a
  end

  def self.update_user_colors(user, colors)
    COLORS.each { |color| user.send("#{color}=", false) }
    colors.each { |color| user.send("#{color}=", true) }
    user.save!
  end

  def self.count_by_color(color)
    ::User.send(color).count
  end
end
