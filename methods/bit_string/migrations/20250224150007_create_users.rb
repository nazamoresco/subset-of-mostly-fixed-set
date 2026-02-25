# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.column :favorite_colors, 'bit(12)', default: '0'

      t.timestamps
    end

    add_index :users, :favorite_colors
  end
end
