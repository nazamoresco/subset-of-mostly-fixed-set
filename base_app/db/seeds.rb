# frozen_string_literal: true

# Create sample users with favorite colors
users_data = [
  { favorite_colors: %w[red blue green] },
  { favorite_colors: %w[yellow purple orange pink] },
  { favorite_colors: %w[cyan magenta lime teal indigo] },
  { favorite_colors: %w[red yellow] },
  { favorite_colors: %w[blue purple pink cyan] }
]

users_data.each do |data|
  User.find_or_create_by!(favorite_colors: data[:favorite_colors])
end

puts "Created #{User.count} users"
