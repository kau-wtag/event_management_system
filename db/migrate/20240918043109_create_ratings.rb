class CreateRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :ratings do |t|
      t.integer :rating, null: false  # Rating from 1-10
      t.text :review  # Optional text review
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end

    # Ensure that a user can rate an event only once
    add_index :ratings, [:user_id, :event_id], unique: true
  end
end
