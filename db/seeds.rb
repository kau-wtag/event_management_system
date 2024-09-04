# db/seeds.rb

# Destroy existing records to avoid duplicates
User.destroy_all
Category.destroy_all
Event.destroy_all

# Create some sample users
admin_user = User.create!(name: 'admin', email: 'admin@gmail.com', password: 'adminadmin', admin: true)
puts "Admin user created!"

# Create sample categories
categories = Category.create!([
  { name: 'Music' },
  { name: 'Tech' },
  { name: 'Art' },
  { name: 'Food' },
  { name: 'Sports' },
  { name: 'Books' },
  { name: 'Comedy' },
  { name: 'Film' },
  { name: 'Wellness' },
  { name: 'Business' }
])

puts "#{Category.count} categories created!"

# Create some sample events and associate them with categories
events = Event.create!([
  { name: "Music Festival", location: "Central Park, NYC", price: 49.99, starts_at: DateTime.now + 30.days, description: "An exciting music festival featuring popular bands and artists.", category: categories[0] },
  { name: "Tech Conference", location: "San Francisco, CA", price: 199.99, starts_at: DateTime.now + 60.days, description: "A conference for tech enthusiasts and professionals.", category: categories[1] },
  { name: "Art Exhibition", location: "Los Angeles, CA", price: 29.99, starts_at: DateTime.now + 15.days, description: "A showcase of modern and contemporary art pieces.", category: categories[2] },
  { name: "Food Fair", location: "Austin, TX", price: 9.99, starts_at: DateTime.now + 10.days, description: "A fair with a variety of food trucks and vendors.", category: categories[3] },
  { name: "Marathon", location: "Boston, MA", price: 0.00, starts_at: DateTime.now + 45.days, description: "A marathon event open to all participants.", category: categories[4] },
  { name: "Book Signing", location: "Seattle, WA", price: 15.00, starts_at: DateTime.now + 20.days, description: "Meet your favorite authors and get your books signed.", category: categories[5] },
  { name: "Comedy Show", location: "Chicago, IL", price: 25.00, starts_at: DateTime.now + 25.days, description: "A night of laughter with top comedians.", category: categories[6] },
  { name: "Film Festival", location: "Sundance, UT", price: 100.00, starts_at: DateTime.now + 90.days, description: "A festival showcasing independent films.", category: categories[7] },
  { name: "Yoga Retreat", location: "Boulder, CO", price: 300.00, starts_at: DateTime.now + 120.days, description: "A relaxing retreat focusing on yoga and wellness.", category: categories[8] },
  { name: "Startup Pitch", location: "Palo Alto, CA", price: 49.99, starts_at: DateTime.now + 35.days, description: "An event for startups to pitch their ideas to investors.", category: categories[9] }
])

puts "#{Event.count} events created!"

puts 'Seed data generated successfully!'
