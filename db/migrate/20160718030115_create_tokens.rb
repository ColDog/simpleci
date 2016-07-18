class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.references    :user,     foreign_key: true
      t.string        :key,      null: false, index: true, unique: true
      t.string        :secret,   null: false

      t.timestamps
    end
  end
end
