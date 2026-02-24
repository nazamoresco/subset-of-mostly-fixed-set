


# Benchmark Results

## Leaderboard (lower is better)

| Name | Create User (s) | Find by Color (s) | Update Colors (s) |
|------|------------------|-------------------|-------------------|
| active_flag | 11.23 | 2.82 | 0.02 |
| array_enum | 6.96 | 12.07 | 0.32 |
| junction_table | 32.70 | 14.46 | 5.42 |
| postgres_string_array | 7.12 | 13.09 | 0.35 |

## Detailed Results

### active_flag

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 5.59 | 0.87 | 6.46 | 11.23 |
| Find by color | 1.16 | 0.26 | 1.42 | 2.82 |
| Update colors | 0.02 | 0.00 | 0.02 | 0.02 |

### array_enum

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 3.49 | 0.44 | 3.94 | 6.96 |
| Find by color | 9.07 | 0.13 | 9.20 | 12.07 |
| Update colors | 0.17 | 0.01 | 0.18 | 0.32 |

### junction_table

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 17.11 | 1.34 | 18.45 | 32.70 |
| Find by color | 9.74 | 0.14 | 9.88 | 14.46 |
| Update colors | 2.80 | 0.40 | 3.20 | 5.42 |

### postgres_string_array

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 3.46 | 0.46 | 3.92 | 7.12 |
| Find by color | 9.75 | 0.14 | 9.90 | 13.09 |
| Update colors | 0.16 | 0.01 | 0.17 | 0.35 |