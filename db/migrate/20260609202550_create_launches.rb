class CreateLaunches < ActiveRecord::Migration[8.1]
  def change
    create_table :launches do |t|
      t.string :spacex_id
      t.string :name
      t.datetime :date_utc
      t.boolean :success
      t.text :details
      t.integer :flight_number
      t.json :raw_data
      t.references :rocket, null: false, foreign_key: true
      t.references :launchpad, null: false, foreign_key: true

      t.timestamps
    end
  end
end
