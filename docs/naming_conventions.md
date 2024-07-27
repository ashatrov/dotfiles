# Naming Convention

## Table Names

  1. Regular Table Names
      - Use `snake_case` for table names.
      - Use plural nouns for table names (e.g., `users`, `therapies`, `payments`). If the table name consists of two words, then only the last one is plural (e.g., `practitioner_profiles`, `practitioner_profile_photos`).
      - Format: `[singular]_[singular]_[singular]_[plural]`
  
  1. Table Names for Many-to-Many Connections
      - Use `snake_case`.
      - Combine the names of the two entities involved, typically in alphabetical order and pluralized (e.g., `users_roles`, `products_categories`).
      - Format: `[table_name]_[table_name]`

## Column Names

  1. Column Names for One-to-Many or One-to-One Connections
      - Use `snake_case`.
      - Use the singular form of the related table name followed by `_id` (e.g., `user_id` for a reference to a `users` table).

## Indexes

  1. Indexes for One Column
      - Use the prefix `idx_` followed by the table name and the column name (e.g., `idx_users_email` for an index on the `email` column in the `users` table).
      - Format: `idx_[table_name]_[column]`
  
  1. Indexes with Multiple Columns
      - Use the prefix `idx_` followed by the table name and all column names separated by underscores (e.g., `idx_appointments_user_id_created_at` for an index on `user_id` and `created_at` columns in the `appointments` table).
      - Format: `idx_[table_name]_[column]_[column]_[column]`

## Foreign Keys

  - Use the prefix `fk_` followed by the table name, the referenced table name, and the column name (e.g., `fk_appointments_users_user_id` for a foreign key from `appointments.user_id` referencing `users.id`).
  - Format: `fk_[table_name]_[reference_table_name]_[table_column_name]`

    ~~Wrong~~: `fk_[table_name]_[reference_table_name]_[reference_table_column_name]`
