# frozen_string_literal: true

# Seed colors first (required for junction table approach)
COLORS.each do |color_name|
  Color.find_or_create_by!(name: color_name)
end

puts "✓ Seeded #{Color.count} colors"
