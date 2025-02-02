# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Create some sample users
User.destroy_all
User.create(name: 'John Doe', email: 'john@example.com', password: 'password')
User.create(name: 'Jane Smith', email: 'jane@example.com', password: 'password')
User.create(name: 'Alice Johnson', email: 'alice@example.com', password: 'password')
puts 'Seed data generated successfully!'
