# Subset of Fixed Set Storage Benchmark

This project compares different methods of storing a subset of a mostly constant set of values.

## Example Use Case

Each **User** has a set of **favorite colors** that is a subset of a mostly constant set of available colors.

**Colors (mostly constant set):**
- Red
- Green
- Blue
- Yellow
- Purple
- Orange
- Pink
- Cyan
- Magenta
- Lime
- Teal
- Indigo

**User data:**
| User ID | Favorite Colors                    |
|---------|------------------------------------|
| 1       | Red, Blue, Green                   |
| 2       | Yellow, Purple, Orange, Pink       |
| 3       | Cyan, Magenta, Lime, Teal, Indigo  |

## Implementation

Each storage method is defined in the `methods/` folder with:
- `Gemfile` - Gems to install on top of the base app
- `migrations/` - Database migrations
- `models/` - ActiveRecord models
- `operations.rb` - Method-specific operations (create_user, find_by_color, etc.)

A single **base Rails app** (`base_app/`) serves as the foundation. The `benchmark.rb` script applies each method's configuration, runs benchmarks, and cleans up.

## Structure

```
.
├── README.md
├── benchmark.rb        # Benchmark runner script
├── docker-compose.yml  # PostgreSQL for benchmarks
├── base_app/          # Base Rails application
│   ├── Gemfile
│   ├── app/
│   ├── config/
│   └── db/
└── methods/           # Storage method configurations
    ├── array_enum/
    │   ├── Gemfile
    │   ├── operations.rb
    │   ├── migrations/
    │   └── models/
    ├── active_flag/
    │   ├── Gemfile
    │   ├── operations.rb
    │   ├── migrations/
    │   └── models/
    ├── junction_table/
    │   ├── Gemfile
    │   ├── operations.rb
    │   ├── migrations/
    │   ├── models/
    │   └── seeds.rb
    └── postgres_string_array/
        ├── Gemfile
        ├── operations.rb
        ├── migrations/
        └── models/
```

## Methods

1. **[Array Enum](methods/array_enum/)** - PostgreSQL array with `array_enum` gem (integer mapping)
2. **[Active Flag](methods/active_flag/)** - Bitwise flags using `active_flag` gem
3. **[PostgreSQL String Array](methods/postgres_string_array/)** - Native PostgreSQL string array with GIN index
4. **[Junction Table](methods/junction_table/)** - Many-to-many relationship with separate colors table

## Getting Started

### Prerequisites

- Ruby 3.3.8
- Docker & Docker Compose

### Setup

1. **Start PostgreSQL:**
   ```bash
   docker-compose up -d
   ```

2. **Install base app dependencies:**
   ```bash
   cd base_app
   bundle install
   cd ..
   ```

### Running Benchmarks

Run benchmarks for a specific method:

```bash
# Array Enum method
ruby benchmark.rb array_enum

# Active Flag method
ruby benchmark.rb active_flag

# Junction Table method
ruby benchmark.rb junction_table

# PostgreSQL String Array method
ruby benchmark.rb postgres_string_array
```

The script will:
1. Add method-specific gems to the base app's Gemfile
2. Copy migrations and models
3. Install gems and run migrations
4. Seed test data
5. Run performance benchmarks
6. Clean up (restore original files, reset database)

### Adding a New Method

To add a new storage method:

1. Create a folder in `methods/`:
   ```
   methods/my_method/
   ├── Gemfile
   ├── operations.rb
   ├── migrations/
   │   └── xxx_create_users.rb
   └── models/
       └── user.rb
   ```

2. Define the gems in `Gemfile`:
   ```ruby
   # methods/my_method/Gemfile
   gem "my_gem"
   ```

3. Implement operations in `operations.rb`:
   ```ruby
   # methods/my_method/operations.rb
   module Operations
     def self.create_user(colors)
       # implementation
     end

     def self.find_by_color(color)
       # implementation
     end

     def self.update_user_colors(user, colors)
       # implementation
     end

     def self.count_by_color(color)
       # implementation
     end
    end
    ```

4. Create migrations in `migrations/`:
    ```ruby
    # methods/my_method/migrations/xxx_create_users.rb
   class CreateUsers < ActiveRecord::Migration[8.1]
     def change
       create_table :users do |t|
         # your schema
         t.timestamps
       end
     end
    end
    ```

5. Create models in `models/`:
    ```ruby
    # methods/my_method/models/user.rb
    class User < ApplicationRecord
      # your model code
    end
    ```

6. Run the benchmark:
    ```bash
    ruby benchmark.rb my_method
    ```

## Benchmarks

Benchmarks measure:
- **Create user** - Time to insert a user with favorite colors
- **Find by color** - Time to query users by a specific color
- **Update colors** - Time to update a user's favorite colors

Results include database statistics (total users, etc.).

See [RESULTS.md](RESULTS.md) for detailed benchmark results and leaderboard.
