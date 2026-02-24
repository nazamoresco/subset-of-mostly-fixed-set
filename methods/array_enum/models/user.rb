# frozen_string_literal: true

class User < ApplicationRecord
  array_enum favorite_colors: %w[red green blue yellow purple orange pink cyan magenta lime teal indigo]
end
