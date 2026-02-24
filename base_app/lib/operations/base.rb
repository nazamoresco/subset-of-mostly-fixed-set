# frozen_string_literal: true

module Operations
  module Base
    # Create a user with the given colors
    # @param colors [Array<String>] array of color names
    # @return [User] created user
    def self.create_user(colors)
      raise NotImplementedError
    end

    # Find users that have a specific color
    # @param color [String] single color name
    # @return [Array<User>] users with that color
    def self.find_by_color(color)
      raise NotImplementedError
    end

    # Update user's favorite colors
    # @param user [User] user to update
    # @param colors [Array<String>] new array of color names
    def self.update_user_colors(user, colors)
      raise NotImplementedError
    end

    # Count users with a specific color
    # @param color [String] single color name
    # @return [Integer] count
    def self.count_by_color(color)
      raise NotImplementedError
    end
  end
end
