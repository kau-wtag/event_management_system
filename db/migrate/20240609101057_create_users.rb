class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'citext' unless extension_enabled?('citext')
    
    create_table :users do |t|
      t.string :name, null: false
      t.citext :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
