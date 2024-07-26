# frozen_string_literal: true

class CreateEntrances < ActiveRecord::Migration[7.1]
  def change
    create_table :entrances do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :entrances, :name, unique: true
  end
end
