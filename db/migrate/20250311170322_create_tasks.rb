class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :status, default: 0
      t.string :link
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
