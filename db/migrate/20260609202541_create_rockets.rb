class CreateRockets < ActiveRecord::Migration[8.1]
  def change
    create_table :rockets do |t|
      t.string :spacex_id
      t.string :name
      t.text :description
      t.date :first_flight
      t.boolean :active

      t.timestamps
    end
  end
end
