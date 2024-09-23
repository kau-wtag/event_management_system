class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name, null: false, limit: 100
      t.text :description
      t.decimal :rent_cost, precision: 10, scale: 2, null: false, default: 0.0
      t.string :google_map_link
      t.string :full_address, null: false
      t.integer :capacity
      t.string :contact_number
      t.string :contact_email
      t.timestamps
    end
  end
end