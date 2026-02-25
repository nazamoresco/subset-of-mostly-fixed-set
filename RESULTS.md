


# Benchmark Results

## Leaderboard (lower is better; ordered by read; N=1000)

| Name | Create User (s) | Find by Color (s) | Update Colors (s) |
|------|------------------|-------------------|-------------------|
| bitfields (bitwise integer) | 6.94 | 11.14 | 0.55 |
| bit_string (bitwise bit string) | 7.30 | 11.78 | 0.76 |
| active_flag (bitwise integer) | 9.17 | 11.82 | 0.67 |
| array_enum (integer array) | 6.96 | 12.07 | 0.32 |
| jsonb_array (jsonb) | 7.38 | 12.83 | 0.59 |
| postgres_string_array (string array) | 7.12 | 13.09 | 0.35 |
| flag_shih_tzu (bitwise integer) | 7.21 | 14.19 | 0.33 |
| junction_table (habtm tables) | 32.70 | 14.46 | 5.42 |

## Detailed Results

### active_flag (bitwise integer)

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 4.08 | 0.55 | 4.64 | 9.17 |
| Find by color | 9.03 | 0.11 | 9.14 | 11.82 |
| Update colors | 0.26 | 0.04 | 0.30 | 0.67 |


### array_enum (integer array)

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 3.49 | 0.44 | 3.94 | 6.96 |
| Find by color | 9.07 | 0.13 | 9.20 | 12.07 |
| Update colors | 0.17 | 0.01 | 0.18 | 0.32 |

### bitfields (bitwise integer)

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 3.65 | 0.56 | 4.21 | 6.94 |
| Find by color | 8.68 | 0.10 | 8.78 | 11.14 |
| Update colors | 0.19 | 0.02 | 0.21 | 0.55 |

### bit_string (bitwise bit string)

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 3.66 | 0.50 | 4.15 | 7.30 |
| Find by color | 8.98 | 0.13 | 9.11 | 11.78 |
| Update colors | 0.34 | 0.04 | 0.38 | 0.76 |

### flag_shih_tzu (bitwise integer)

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 3.61 | 0.48 | 4.10 | 7.21 |
| Find by color | 9.72 | 0.14 | 9.86 | 14.19 |
| Update colors | 0.14 | 0.01 | 0.15 | 0.33 |

### jsonb_array (jsonb)

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 3.85 | 0.53 | 4.38 | 7.38 |
| Find by color | 9.13 | 0.15 | 9.28 | 12.83 |
| Update colors | 0.24 | 0.03 | 0.27 | 0.59 |

### junction_table (habtm tables)

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 17.11 | 1.34 | 18.45 | 32.70 |
| Find by color | 9.74 | 0.14 | 9.88 | 14.46 |
| Update colors | 2.80 | 0.40 | 3.20 | 5.42 |

### postgres_string_array (string array)

| Operation | user | system | total | real |
|-----------|------|--------|-------|------|
| Create user | 3.46 | 0.46 | 3.92 | 7.12 |
| Find by color | 9.75 | 0.14 | 9.90 | 13.09 |
| Update colors | 0.16 | 0.01 | 0.17 | 0.35 |