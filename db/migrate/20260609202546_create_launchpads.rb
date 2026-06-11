class CreateLaunchpads < ActiveRecord::Migration[8.1]
  def change
    create_table :launchpads do |t|
      t.string :spacex_id
      t.string :name
      t.string :full_name
      t.string :locality
      t.string :region
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
