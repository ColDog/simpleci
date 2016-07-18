class CreateJobDefinitions < ActiveRecord::Migration[5.0]
  def change
    create_table :job_definitions do |t|
      t.references  :user, foreign_key: true, null: false
      t.string      :name,  null: false

      t.json        :triggered_by
      t.json        :repo
      t.json        :build

      t.timestamps
    end
  end
end
