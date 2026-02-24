# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.integer :favorite_colors, array: true, null: false, default: []

      t.timestamps
    end

    add_index :users, :favorite_colors, using: 'gin'
  end
end
