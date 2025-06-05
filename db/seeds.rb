# This file should contain all the record creation needed to seed the database with its default values.

# Ensure the default user exists, creating them if necessary
default_user_email = "default@example.com"
user = User.find_or_create_by!(email: default_user_email) do |u|
  u.password = "password" # You can set a default password here
  u.password_confirmation = "password"
  puts "Created default user: #{default_user_email}"
end
puts "Using user: #{user.email} (ID: #{user.id}) for seeding subscriptions."

# Clear out old data carefully
# Destroy subscriptions associated with the specific user first
puts "Destroying existing subscriptions for user: #{user.email}..."
user.subscriptions.destroy_all

# Destroy all categories.
# Note: If subscriptions belong_to category and have dependent: :destroy or :nullify,
# this might be handled automatically or you might want to be more specific.
# For now, a direct destroy_all is used as per your original file structure.
puts "Destroying all existing categories..."
Category.destroy_all

# --- Recreate Categories ---
puts "Creating categories..."
other = Category.create!(name: "Other")
entertainment = Category.create!(name: "Entertainment")
housing = Category.create!(name: "Housing")
utilities = Category.create!(name: "Utilities")
streaming = Category.create!(name: "Streaming Services")
food_delivery = Category.create!(name: "Food Delivery")
news_magazines = Category.create!(name: "News & Magazines")
software = Category.create!(name: "Software")
fitness = Category.create!(name: "Fitness")
education = Category.create!(name: "Education")
travel = Category.create!(name: "Travel")
health = Category.create!(name: "Health & Wellness")
puts "#{Category.count} categories created."

# --- Add Subscriptions for the default user ---
puts "Creating subscriptions for user: #{user.email}..."
add_subscriptions = [
  # Streaming Services
  { name: 'Netflix Standard Plan',      price: 15.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-15'), notes: '', category: streaming, notification_days_before: 7 },
  { name: 'Hulu Basic',                 price: 7.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-20'), notes: '', category: streaming, notification_days_before: 7 },
  { name: 'Disney+ Subscription',       price: 7.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-10'), notes: '', category: streaming, notification_days_before: 7 },
  { name: 'Spotify Premium',            price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-18'), notes: '', category: streaming, notification_days_before: 7 },

  # Utilities
  { name: 'Xfinity Internet',           price: 59.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-05'), notes: '', category: utilities, notification_days_before: 7 },
  { name: 'Verizon Wireless',           price: 39.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-12'), notes: '', category: utilities, notification_days_before: 7 },
  { name: 'City Water Utility',         price: 25.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-08'), notes: '', category: utilities, notification_days_before: 7 },
  { name: 'Gas Company Service',        price: 30.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-09'), notes: '', category: utilities, notification_days_before: 7 },

  # Food Delivery
  { name: 'Uber Eats Plus',             price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-14'), notes: '', category: food_delivery, notification_days_before: 7 },
  { name: 'DoorDash DashPass',          price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-11'), notes: '', category: food_delivery, notification_days_before: 7 },
  { name: 'Grubhub+',                   price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-13'), notes: '', category: food_delivery, notification_days_before: 7 },
  { name: 'Postmates Unlimited',        price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-16'), notes: '', category: food_delivery, notification_days_before: 7 },

  # News & Magazines
  { name: 'New York Times Digital',     price: 17.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-02'), notes: '', category: news_magazines, notification_days_before: 7 },
  { name: 'Wall Street Journal',        price: 22.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-03'), notes: '', category: news_magazines, notification_days_before: 7 },
  { name: 'Wired Magazine',             price: 12.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-04'), notes: '', category: news_magazines, notification_days_before: 7 },
  { name: 'Medium Membership',          price: 5.00,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-06'), notes: '', category: news_magazines, notification_days_before: 7 },

  # Software
  { name: 'Microsoft 365 Personal',     price: 69.99, billing_cycle: 'Yearly',  next_payment_date: Date.parse('2026-05-13'), notes: '', category: software, notification_days_before: 7 },
  { name: 'Adobe Creative Cloud',       price: 52.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-07'), notes: '', category: software, notification_days_before: 7 },
  { name: 'JetBrains All Products Pack',price: 249.00,billing_cycle: 'Yearly',  next_payment_date: Date.parse('2026-05-13'), notes: '', category: software, notification_days_before: 7 },
  { name: 'Zoom Pro',                   price: 14.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-17'), notes: '', category: software, notification_days_before: 7 },

  # Fitness
  { name: 'Peloton App',                price: 12.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-19'), notes: '', category: fitness, notification_days_before: 7 },
  { name: 'ClassPass',                  price: 45.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-20'), notes: '', category: fitness, notification_days_before: 7 },
  { name: 'Local Gym Membership',       price: 29.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-21'), notes: '', category: fitness, notification_days_before: 7 },
  { name: 'Strava Summit',              price: 7.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-22'), notes: '', category: fitness, notification_days_before: 7 },

  # Education
  { name: 'Coursera Plus',              price: 49.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-15'), notes: '', category: education, notification_days_before: 7 },
  { name: 'LinkedIn Learning',          price: 29.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-16'), notes: '', category: education, notification_days_before: 7 },
  { name: 'Skillshare Premium',         price: 19.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-17'), notes: '', category: education, notification_days_before: 7 },
  { name: 'MasterClass Subscription',   price: 15.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-18'), notes: '', category: education, notification_days_before: 7 },

  # Travel
  { name: 'AAA Membership',             price: 59.00, billing_cycle: 'Yearly',  next_payment_date: Date.parse('2026-05-13'), notes: '', category: travel, notification_days_before: 7 },
  { name: 'Priority Pass',              price: 99.00, billing_cycle: 'Yearly',  next_payment_date: Date.parse('2026-05-13'), notes: '', category: travel, notification_days_before: 7 },
  { name: 'SpotHero Premium',           price: 5.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-10'), notes: '', category: travel, notification_days_before: 7 },
  { name: 'Travelzoo Premium',          price: 14.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-11'), notes: '', category: travel, notification_days_before: 7 },

  # Entertainment
  { name: 'Cinemark Movie Club',        price: 8.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-12'), notes: '', category: entertainment, notification_days_before: 7 },
  { name: 'Audible Membership',         price: 14.95, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-13'), notes: '', category: entertainment, notification_days_before: 7 },
  { name: 'PlayStation Plus',           price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-14'), notes: '', category: entertainment, notification_days_before: 7 },
  { name: 'Xbox Game Pass',             price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-15'), notes: '', category: entertainment, notification_days_before: 7 },

  # Health & Wellness
  { name: 'Headspace',                  price: 12.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-16'), notes: '', category: health, notification_days_before: 7 },
  { name: 'Calm',                       price: 14.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-17'), notes: '', category: health, notification_days_before: 7 },
  { name: 'Fitbit Premium',             price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-18'), notes: '', category: health, notification_days_before: 7 },
  { name: 'Noom',                       price: 59.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-19'), notes: '', category: health, notification_days_before: 7 }
]

add_subscriptions.each do |subscription_attrs|
  
  # Ensure the user_id is set correctly when creating subscriptions
  user.subscriptions.create!(subscription_attrs)
end

puts "Seeded #{user.subscriptions.count} subscriptions for #{user.email}"