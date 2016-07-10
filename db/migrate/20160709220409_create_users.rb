class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :provider
      t.string :token
      t.string :uid

      t.timestamps
    end
  end
end