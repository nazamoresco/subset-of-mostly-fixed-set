# frozen_string_literal: true

module Operations
  # Build color to flag mapping from COLORS constant
  COLOR_TO_FLAG = COLORS.each_with_object({}).with_index do |(color, hash), index|
    hash[color] = color.to_sym
  end.freeze

  def self.create_user(colors)
    user = User.new
    colors.each do |color|
      flag = COLOR_TO_FLAG[color]
      user.send("#{flag}=", true) if flag
    end
    user.save!
    user
  end

  def self.find_by_color(color)
    flag = COLOR_TO_FLAG[color]
    return [] unless flag

    User.send("#{flag}")
  end

  def self.update_user_colors(user, colors)
    # Clear all flags first
    COLOR_TO_FLAG.values.each do |flag|
      user.send("#{flag}=", false)
    end

    # Set new flags
    colors.each do |color|
      flag = COLOR_TO_FLAG[color]
      user.send("#{flag}=", true) if flag
    end

    user.save!
  end

  def self.count_by_color(color)
    flag = COLOR_TO_FLAG[color]
    return 0 unless flag

    User.send("#{flag}").count
  end
end
