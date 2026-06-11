class AdaptSchemaToLaunchLibrary < ActiveRecord::Migration[8.1]
  def change
    rename_column :launches, :spacex_id, :external_id
    rename_column :rockets, :spacex_id, :external_id
    rename_column :launchpads, :spacex_id, :external_id
    remove_column :launches, :flight_number, :integer  # LL2 non ha un flight number globale
    add_column :launches, :provider_name, :string       # es. "SpaceX", "CASC" — per filtrare per provider
    add_index :launches, :provider_name
  end
end