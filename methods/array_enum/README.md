# Array Enum Method

Stores favorite colors as a PostgreSQL array of strings with enum-like behavior using the `array_enum` gem.

## Files

- `gems.rb` - Gem definition
- `migrations/20250224150000_create_users.rb` - Database schema
- `models/user.rb` - User model

## Schema

```ruby
create_table :users do |t|
  t.string :favorite_colors, array: true, default: []
  t.timestamps
end
add_index :users, :favorite_colors, using: 'gin'
```

## Model

```ruby
class User < ApplicationRecord
  array_enum favorite_colors: %w[red green blue yellow purple orange pink cyan magenta lime teal indigo]
end
```

## Usage

```ruby
# Create
User.create(favorite_colors: %w[red blue green])

# Query
User.where(favorite_colors: 'red')
User.where(favorite_colors: %w[red blue])

# Update
user.favorite_colors << 'purple'
user.save
```

## Pros

- Native PostgreSQL array support
- GIN index for fast queries
- Simple single-column schema
- Type safety with array_enum gem

## Cons

- PostgreSQL-specific
- No referential integrity
