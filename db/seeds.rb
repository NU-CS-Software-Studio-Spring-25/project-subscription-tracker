Subscription.destroy_all
Category.destroy_all

user = User.find_by(email: "default@example.com")
raise "Seed user not found!" unless user
user.subscriptions.destroy_all

Category.destroy_all
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

add_subscriptions = [
  # Streaming Services
  { name: 'Netflix Standard Plan',      price: 15.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-15'), notes: '', category: streaming },
  { name: 'Hulu Basic',                 price: 7.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-20'), notes: '', category: streaming },
  { name: 'Disney+ Subscription',       price: 7.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-10'), notes: '', category: streaming },
  { name: 'Spotify Premium',            price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-18'), notes: '', category: streaming },

  # Utilities
  { name: 'Xfinity Internet',           price: 59.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-05'), notes: '', category: utilities },
  { name: 'Verizon Wireless',           price: 39.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-12'), notes: '', category: utilities },
  { name: 'City Water Utility',         price: 25.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-08'), notes: '', category: utilities },
  { name: 'Gas Company Service',        price: 30.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-09'), notes: '', category: utilities },

  # Food Delivery
  { name: 'Uber Eats Plus',             price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-14'), notes: '', category: food_delivery },
  { name: 'DoorDash DashPass',          price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-11'), notes: '', category: food_delivery },
  { name: 'Grubhub+',                   price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-13'), notes: '', category: food_delivery },
  { name: 'Postmates Unlimited',        price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-16'), notes: '', category: food_delivery },

  # News & Magazines
  { name: 'New York Times Digital',     price: 17.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-02'), notes: '', category: news_magazines },
  { name: 'Wall Street Journal',        price: 22.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-03'), notes: '', category: news_magazines },
  { name: 'Wired Magazine',             price: 12.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-04'), notes: '', category: news_magazines },
  { name: 'Medium Membership',          price: 5.00,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-06'), notes: '', category: news_magazines },

  # Software
  { name: 'Microsoft 365 Personal',     price: 69.99, billing_cycle: 'Yearly',  next_payment_date: Date.parse('2026-05-13'), notes: '', category: software },
  { name: 'Adobe Creative Cloud',       price: 52.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-07'), notes: '', category: software },
  { name: 'JetBrains All Products Pack',price: 249.00,billing_cycle: 'Yearly',  next_payment_date: Date.parse('2026-05-13'), notes: '', category: software },
  { name: 'Zoom Pro',                   price: 14.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-17'), notes: '', category: software },

  # Fitness
  { name: 'Peloton App',                price: 12.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-19'), notes: '', category: fitness },
  { name: 'ClassPass',                  price: 45.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-20'), notes: '', category: fitness },
  { name: 'Local Gym Membership',       price: 29.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-21'), notes: '', category: fitness },
  { name: 'Strava Summit',              price: 7.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-22'), notes: '', category: fitness },

  # Education
  { name: 'Coursera Plus',              price: 49.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-15'), notes: '', category: education },
  { name: 'LinkedIn Learning',          price: 29.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-16'), notes: '', category: education },
  { name: 'Skillshare Premium',         price: 19.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-17'), notes: '', category: education },
  { name: 'MasterClass Subscription',   price: 15.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-18'), notes: '', category: education },

  # Travel
  { name: 'AAA Membership',             price: 59.00, billing_cycle: 'Yearly',  next_payment_date: Date.parse('2026-05-13'), notes: '', category: travel },
  { name: 'Priority Pass',              price: 99.00, billing_cycle: 'Yearly',  next_payment_date: Date.parse('2026-05-13'), notes: '', category: travel },
  { name: 'SpotHero Premium',           price: 5.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-10'), notes: '', category: travel },
  { name: 'Travelzoo Premium',          price: 14.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-11'), notes: '', category: travel },

  # Entertainment
  { name: 'Cinemark Movie Club',        price: 8.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-12'), notes: '', category: entertainment },
  { name: 'Audible Membership',         price: 14.95, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-13'), notes: '', category: entertainment },
  { name: 'PlayStation Plus',           price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-14'), notes: '', category: entertainment },
  { name: 'Xbox Game Pass',             price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-15'), notes: '', category: entertainment },

  # Health & Wellness (category_id = 10)
  { name: 'Headspace',                  price: 12.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-16'), notes: '', category: health },
  { name: 'Calm',                       price: 14.99, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-17'), notes: '', category: health },
  { name: 'Fitbit Premium',             price: 9.99,  billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-18'), notes: '', category: health },
  { name: 'Noom',                       price: 59.00, billing_cycle: 'Monthly', next_payment_date: Date.parse('2025-06-19'), notes: '', category: health }
]

add_subscriptions.each do |subscription|
    user.subscriptions.create!(subscription)
end

puts "Seeded #{user.subscriptions.count} subscriptions for #{user.email}"
