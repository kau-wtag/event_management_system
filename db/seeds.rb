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
User.create(name: 'admin', email: 'admin@gmail.com', password: 'adminadmin')
User.create(name: 'Jane Smith', email: 'jane@example.com', password: 'password')
User.create(name: 'Alice Johnson', email: 'alice@example.com', password: 'password')

Event.destroy_all
Event.create([
  { name: "Music Festival", location: "Central Park, NYC", price: 49.99, starts_at: DateTime.now + 30.days, description: "An exciting music festival featuring popular bands and artists." },
  { name: "Tech Conference", location: "San Francisco, CA", price: 199.99, starts_at: DateTime.now + 60.days, description: "A conference for tech enthusiasts and professionals." },
  { name: "Art Exhibition", location: "Los Angeles, CA", price: 29.99, starts_at: DateTime.now + 15.days, description: "A showcase of modern and contemporary art pieces." },
  { name: "Food Fair", location: "Austin, TX", price: 9.99, starts_at: DateTime.now + 10.days, description: "A fair with a variety of food trucks and vendors." },
  { name: "Marathon", location: "Boston, MA", price: 0.00, starts_at: DateTime.now + 45.days, description: "A marathon event open to all participants." },
  { name: "Book Signing", location: "Seattle, WA", price: 15.00, starts_at: DateTime.now + 20.days, description: "Meet your favorite authors and get your books signed." },
  { name: "Comedy Show", location: "Chicago, IL", price: 25.00, starts_at: DateTime.now + 25.days, description: "A night of laughter with top comedians." },
  { name: "Film Festival", location: "Sundance, UT", price: 100.00, starts_at: DateTime.now + 90.days, description: "A festival showcasing independent films." },
  { name: "Yoga Retreat", location: "Boulder, CO", price: 300.00, starts_at: DateTime.now + 120.days, description: "A relaxing retreat focusing on yoga and wellness." },
  { name: "Startup Pitch", location: "Palo Alto, CA", price: 49.99, starts_at: DateTime.now + 35.days, description: "An event for startups to pitch their ideas to investors." }
])


puts 'Seed data generated successfully!'
