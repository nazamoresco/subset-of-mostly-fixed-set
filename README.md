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
- `gems.rb` - Gems to install on top of the base app
- `migrations/` - Database migrations
- `models/` - ActiveRecord models

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
    └── array_enum/
        ├── gems.rb
        ├── migrations/
        └── models/
```

## Methods

1. **[Array Enum](methods/array_enum/)** - PostgreSQL array with `array_enum` gem

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
ruby benchmark.rb array_enum
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
   ├── gems.rb
   ├── migrations/
   │   └── xxx_create_users.rb
   └── models/
       └── user.rb
   ```

2. Define the gems in `gems.rb`:
   ```ruby
   # methods/my_method/gems.rb
   gem "my_gem"
   ```

3. Create migrations in `migrations/`:
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

4. Create models in `models/`:
   ```ruby
   # methods/my_method/models/user.rb
   class User < ApplicationRecord
     # your model code
   end
   ```

5. Run the benchmark:
   ```bash
   ruby benchmark.rb my_method
   ```

## Benchmarks

Benchmarks measure:
- **Create user** - Time to insert a user with favorite colors
- **Find by color** - Time to query users by a specific color
- **Update colors** - Time to update a user's favorite colors

Results include database statistics (total users, etc.).
