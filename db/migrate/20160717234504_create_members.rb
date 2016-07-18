class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.references :target, foreign_key: { to_table: :users }
      t.references :source, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
