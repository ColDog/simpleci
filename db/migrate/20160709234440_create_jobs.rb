class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.references :job_definition, foreign_key: true, null: false
      t.references :user,           foreign_key: true

      t.integer :job_id,        unique: true, null: false, index: true
      t.string  :key,           unique: true, index: true, null: false
      t.json    :build,         null: false
      t.json    :repo

      t.string  :stored_output_url
      t.string  :worker,        index: true
      t.boolean :complete,      default: false
      t.boolean :cancelled,     default: false
      t.boolean :failed,        default: false
      t.text    :failure

      t.timestamps
    end
  end
end
