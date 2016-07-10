class CreateRepos < ActiveRecord::Migration[5.0]
  def change
    create_table :repos do |t|
      t.string :name, null: false
      t.string :provider, null: false
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true
      t.references :config, foreign_key: true

      t.timestamps
    end
  end
end
