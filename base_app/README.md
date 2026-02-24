# Array Enum Method

Stores favorite colors as a PostgreSQL array of strings with enum-like behavior.

## Setup

1. **Start PostgreSQL** (from project root):
   ```bash
   docker-compose up -d
   ```

2. **Setup database:**
   ```bash
   cd databases/array_enum
   bundle install
   bin/rails db:create db:migrate db:seed
   ```

## Schema

```ruby
# db/migrate/xxx_create_users.rb
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

## Usage Examples

```ruby
# Create user with favorite colors
user = User.create(favorite_colors: %w[red blue green])

# Find users who like red
User.where(favorite_colors: 'red')

# Find users who like red OR blue
User.where(favorite_colors: %w[red blue])

# Add favorite color
user.favorite_colors << 'purple'
user.save

# Remove favorite color
user.favorite_colors.delete('red')
user.save
```

## Pros

- Native PostgreSQL array support
- GIN index for fast queries
- Simple schema (single column)
- Built-in Rails support for arrays
- Type safety with array_enum gem

## Cons

- Array operations can be slower than normalized tables for very large datasets
- PostgreSQL-specific (not portable to other databases)
- No referential integrity on color values
