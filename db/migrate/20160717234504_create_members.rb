class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.references :target, foreign_key: true, references: :users
      t.references :source, foreign_key: true, references: :users

      t.timestamps
    end
  end
end
