class CreateVariables < ActiveRecord::Migration[5.0]
  def change
    create_table :variables do |t|
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.string :key
      t.string :value
      t.string :encrypted_value
      t.integer :key_version

      t.timestamps
    end
  end
end
