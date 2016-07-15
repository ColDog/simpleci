class CreateSecrets < ActiveRecord::Migration[5.0]
  def change
    create_table :secrets do |t|
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.string    :key
      t.string    :value
      t.datetime  :lease

      t.timestamps
    end
  end
end
