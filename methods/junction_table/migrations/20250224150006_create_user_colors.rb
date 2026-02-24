# frozen_string_literal: true

class CreateUserColors < ActiveRecord::Migration[8.1]
  def change
    create_table :user_colors do |t|
      t.references :user, null: false, foreign_key: true
      t.references :color, null: false, foreign_key: true
      t.timestamps
    end

    add_index :user_colors, [:user_id, :color_id], unique: true
  end
end
