class CreateFollows < ActiveRecord::Migration[7.1]
  def change
    create_table :follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :organizer, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end

    # Ensure that a user can follow an organizer only once
    add_index :follows, [:follower_id, :organizer_id], unique: true
  end
end
