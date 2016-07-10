class CreateConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :configs do |t|
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.string :name
      t.json :body

      t.timestamps
    end
  end
end
