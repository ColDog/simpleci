class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references  :user, foreign_key: true
      t.string      :name
      t.json        :payload

      t.text        :last_error,  null: true
      t.boolean     :failed,      default: false, null: false
      t.integer     :attempts,    default: 0, null: false
      t.string      :worker,      index: true

      t.timestamps
    end
  end
end
