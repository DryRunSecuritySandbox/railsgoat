class CreateTimeEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :time_entries do |t|
      t.integer :user_id, null: false
      t.string  :project_code
      t.decimal :hours, precision: 5, scale: 2
      t.text    :notes
      t.boolean :billable, default: true
      t.timestamps
    end
    add_index :time_entries, :user_id
  end
end
