# This file should contain all the record creation needed to seed the database with its default values.

# Helper methods to reduce repetition
def create_user_with_defaults(email, password = "password")
  user = User.find_by(email: email)
  if user
    puts "User #{email} already exists"
    return user
  end
  
  user = User.create!(email: email, password: password, password_confirmation: password)
  puts "Created user: #{email}"
  user
end

def create_subscription_with_defaults(base_attrs)
  defaults = {
    billing_cycle: 'Monthly',
    notes: '',
    notification_days_before: 7
  }
  defaults.merge(base_attrs)
end

# Ensure the default user exists, creating them if necessary
default_user_email = "default@example.com"
user = create_user_with_defaults(default_user_email)
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
categories_data = [
  "Other", "Entertainment", "Housing", "Utilities", "Streaming Services",
  "Food Delivery", "News & Magazines", "Software", "Fitness", 
  "Education", "Travel", "Health & Wellness"
]

# Create categories and store references
categories = {}
categories_data.each do |category_name|
  categories[category_name.parameterize.underscore.to_sym] = Category.create!(name: category_name)
end

# Extract category references for easier access
other = categories[:other]
entertainment = categories[:entertainment]
housing = categories[:housing]
utilities = categories[:utilities]
streaming = categories[:streaming_services]
food_delivery = categories[:food_delivery]
news_magazines = categories[:news_and_magazines]
software = categories[:software]
fitness = categories[:fitness]
education = categories[:education]
travel = categories[:travel]
health = categories[:health_and_wellness]

puts "#{Category.count} categories created."

# --- Add Subscriptions for the default user ---
puts "Creating subscriptions for user: #{user.email}..."

# Define subscription data with more concise structure
subscription_data = [
  # Streaming Services
  ['Netflix Standard Plan', 15.99, 'Monthly', '2025-06-15', streaming],
  ['Hulu Basic', 7.99, 'Monthly', '2025-06-20', streaming],
  ['Disney+ Subscription', 7.99, 'Monthly', '2025-06-10', streaming],
  ['Spotify Premium', 9.99, 'Monthly', '2025-06-18', streaming],

  # Utilities
  ['Xfinity Internet', 59.99, 'Monthly', '2025-06-05', utilities],
  ['Verizon Wireless', 39.99, 'Monthly', '2025-06-12', utilities],
  ['City Water Utility', 25.00, 'Monthly', '2025-06-08', utilities],
  ['Gas Company Service', 30.00, 'Monthly', '2025-06-09', utilities],

  # Food Delivery
  ['Uber Eats Plus', 9.99, 'Monthly', '2025-06-14', food_delivery],
  ['DoorDash DashPass', 9.99, 'Monthly', '2025-06-11', food_delivery],
  ['Grubhub+', 9.99, 'Monthly', '2025-06-13', food_delivery],
  ['Postmates Unlimited', 9.99, 'Monthly', '2025-06-16', food_delivery],

  # News & Magazines
  ['New York Times Digital', 17.00, 'Monthly', '2025-06-02', news_magazines],
  ['Wall Street Journal', 22.00, 'Monthly', '2025-06-03', news_magazines],
  ['Wired Magazine', 12.00, 'Monthly', '2025-06-04', news_magazines],
  ['Medium Membership', 5.00, 'Monthly', '2025-06-06', news_magazines],

  # Software
  ['Microsoft 365 Personal', 69.99, 'Yearly', '2026-05-13', software],
  ['Adobe Creative Cloud', 52.99, 'Monthly', '2025-06-07', software],
  ['JetBrains All Products Pack', 249.00, 'Yearly', '2026-05-13', software],
  ['Zoom Pro', 14.99, 'Monthly', '2025-06-17', software],

  # Fitness
  ['Peloton App', 12.99, 'Monthly', '2025-06-19', fitness],
  ['ClassPass', 45.00, 'Monthly', '2025-06-20', fitness],
  ['Local Gym Membership', 29.99, 'Monthly', '2025-06-21', fitness],
  ['Strava Summit', 7.99, 'Monthly', '2025-06-22', fitness],

  # Education
  ['Coursera Plus', 49.00, 'Monthly', '2025-06-15', education],
  ['LinkedIn Learning', 29.99, 'Monthly', '2025-06-16', education],
  ['Skillshare Premium', 19.00, 'Monthly', '2025-06-17', education],
  ['MasterClass Subscription', 15.00, 'Monthly', '2025-06-18', education],

  # Travel
  ['AAA Membership', 59.00, 'Yearly', '2026-05-13', travel],
  ['Priority Pass', 99.00, 'Yearly', '2026-05-13', travel],
  ['SpotHero Premium', 5.99, 'Monthly', '2025-06-10', travel],
  ['Travelzoo Premium', 14.99, 'Monthly', '2025-06-11', travel],

  # Entertainment
  ['Cinemark Movie Club', 8.99, 'Monthly', '2025-06-12', entertainment],
  ['Audible Membership', 14.95, 'Monthly', '2025-06-13', entertainment],
  ['PlayStation Plus', 9.99, 'Monthly', '2025-06-14', entertainment],
  ['Xbox Game Pass', 9.99, 'Monthly', '2025-06-15', entertainment],

  # Health & Wellness
  ['Headspace', 12.99, 'Monthly', '2025-06-16', health],
  ['Calm', 14.99, 'Monthly', '2025-06-17', health],
  ['Fitbit Premium', 9.99, 'Monthly', '2025-06-18', health],
  ['Noom', 59.00, 'Monthly', '2025-06-19', health]
]

# Create subscriptions using the helper method
subscription_data.each do |name, price, billing_cycle, payment_date, category|
  subscription_attrs = create_subscription_with_defaults({
    name: name,
    price: price,
    billing_cycle: billing_cycle,
    next_payment_date: Date.parse(payment_date),
    category: category
  })
  user.subscriptions.create!(subscription_attrs)
end

puts "Seeded #{user.subscriptions.count} subscriptions for #{user.email}"

# Create additional users for market analysis data
puts "Creating additional users for market analysis..."

# Clear existing users except default user first
puts "Clearing existing additional users..."
User.where.not(email: default_user_email).destroy_all

# Use helper method to create additional users
additional_user_emails = [
  "Alrasheed@SubConscious.nu", 
  "Jacob@SubConscious.nu", 
  "Kurdia@SubConscious.nu", 
  "Mukhtar@SubConscious.nu", 
  "Sofian@SubConscious.nu"
]

additional_user_emails.each do |email|
  create_user_with_defaults(email)
end

# Helper method for creating sample subscriptions with variations
def create_sample_subscriptions_for_market_analysis(users, default_user_email, base_date, categories)
  sample_subscriptions = [
    # Streaming Services (6 services with 5 users each = 30 subscriptions)
    { name: 'Netflix Standard Plan', prices: [15.99, 14.99, 15.99, 16.99, 15.49], category: :streaming, billing_cycle: 'Monthly' },
    { name: 'Hulu Basic', prices: [7.99, 8.99, 6.99, 8.49, 7.49], category: :streaming, billing_cycle: 'Monthly' },
    { name: 'Disney+ Subscription', prices: [7.99, 8.99, 9.99, 7.49, 8.49], category: :streaming, billing_cycle: 'Monthly' },
    { name: 'HBO Max', prices: [14.99, 15.99, 16.99, 14.49, 15.49], category: :streaming, billing_cycle: 'Monthly' },
    { name: 'Amazon Prime Video', prices: [8.99, 9.99, 8.49, 9.49, 8.99], category: :streaming, billing_cycle: 'Monthly' },
    { name: 'Apple TV+', prices: [6.99, 7.99, 6.49, 7.49, 6.99], category: :streaming, billing_cycle: 'Monthly' },
    
    # Software (4 services with 5 users each = 20 subscriptions)
    { name: 'Adobe Creative Cloud', prices: [52.99, 49.99, 54.99, 59.99, 51.99], category: :software, billing_cycle: 'Monthly' },
    { name: 'Microsoft 365 Personal', prices: [6.99, 7.99, 6.49, 7.49, 6.99], category: :software, billing_cycle: 'Monthly' },
    { name: 'Canva Pro', prices: [12.99, 14.99, 11.99, 13.99, 12.49], category: :software, billing_cycle: 'Monthly' },
    { name: 'Figma Professional', prices: [12.00, 15.00, 10.00, 14.00, 13.00], category: :software, billing_cycle: 'Monthly' },
    
    # Fitness (3 services with 5 users each = 15 subscriptions)
    { name: 'Local Gym Membership', prices: [29.99, 39.99, 24.99, 34.99, 45.99], category: :fitness, billing_cycle: 'Monthly' },
    { name: 'Peloton App', prices: [12.99, 14.99, 11.99, 13.99, 12.49], category: :fitness, billing_cycle: 'Monthly' },
    { name: 'MyFitnessPal Premium', prices: [9.99, 11.99, 8.99, 10.99, 9.49], category: :fitness, billing_cycle: 'Monthly' },
    
    # Food Delivery (3 services with 5 users each = 15 subscriptions)
    { name: 'DoorDash DashPass', prices: [9.99, 12.99, 8.99, 11.99, 10.49], category: :food_delivery, billing_cycle: 'Monthly' },
    { name: 'Uber Eats Plus', prices: [9.99, 11.99, 7.99, 10.99, 9.49], category: :food_delivery, billing_cycle: 'Monthly' },
    { name: 'Grubhub+', prices: [9.99, 10.99, 8.99, 11.49, 9.99], category: :food_delivery, billing_cycle: 'Monthly' },
    
    # News & Magazines (3 services with 5 users each = 15 subscriptions)
    { name: 'New York Times Digital', prices: [17.00, 15.00, 19.99, 21.00, 16.99], category: :news_magazines, billing_cycle: 'Monthly' },
    { name: 'Wall Street Journal', prices: [22.00, 19.99, 24.99, 20.99, 23.49], category: :news_magazines, billing_cycle: 'Monthly' },
    { name: 'The Atlantic', prices: [7.99, 8.99, 6.99, 8.49, 7.49], category: :news_magazines, billing_cycle: 'Monthly' },
    
    # Health & Wellness (3 services with 5 users each = 15 subscriptions)
    { name: 'Headspace', prices: [12.99, 14.99, 11.99, 13.99, 12.49], category: :health, billing_cycle: 'Monthly' },
    { name: 'Calm', prices: [14.99, 16.99, 12.99, 15.99, 14.49], category: :health, billing_cycle: 'Monthly' },
    { name: 'BetterHelp', prices: [65.00, 70.00, 60.00, 75.00, 68.00], category: :health, billing_cycle: 'Monthly' },
    
    # Education (3 services with 5 users each = 15 subscriptions)
    { name: 'Coursera Plus', prices: [49.00, 59.00, 39.00, 54.00, 44.00], category: :education, billing_cycle: 'Monthly' },
    { name: 'LinkedIn Learning', prices: [29.99, 34.99, 24.99, 32.99, 27.99], category: :education, billing_cycle: 'Monthly' },
    { name: 'Skillshare Premium', prices: [19.00, 22.00, 16.00, 20.00, 18.00], category: :education, billing_cycle: 'Monthly' },
    
    # Entertainment (2 services with 5 users each = 10 subscriptions)
    { name: 'Audible Plus', prices: [14.95, 16.95, 12.95, 15.95, 14.45], category: :entertainment, billing_cycle: 'Monthly' },
    { name: 'Spotify Premium', prices: [9.99, 10.99, 9.49, 11.99, 9.99], category: :entertainment, billing_cycle: 'Monthly' },
    
    # Utilities (2 services with 5 users each = 10 subscriptions)
    { name: 'VPN Service', prices: [11.99, 9.99, 12.99, 10.99, 11.49], category: :utilities, billing_cycle: 'Monthly' },
    { name: 'Cloud Storage', prices: [9.99, 11.99, 8.99, 10.99, 9.49], category: :utilities, billing_cycle: 'Monthly' }
  ]  # Map category symbols to actual category objects
  category_map = {
    streaming: categories[:streaming_services],
    software: categories[:software],
    fitness: categories[:fitness],
    food_delivery: categories[:food_delivery],
    news_magazines: categories[:news_and_magazines],
    health: categories[:health_and_wellness],
    education: categories[:education],
    entertainment: categories[:entertainment],
    utilities: categories[:utilities]
  }

  sample_subscriptions.each do |sub_data|
    sub_data[:prices].each_with_index do |price, index|
      next if index >= users.count # Skip if we don't have enough users
      
      user = users[index]
      next if user.email == default_user_email # Skip default user to avoid duplicates
      
      subscription_attrs = create_subscription_with_defaults({
        name: sub_data[:name],
        price: price,
        billing_cycle: sub_data[:billing_cycle],
        category: category_map[sub_data[:category]],
        next_payment_date: base_date + rand(1..30).days,
        notification_days_before: [3, 5, 7, 10].sample,
        notes: "Sample data for market analysis"
      })
      
      user.subscriptions.create!(subscription_attrs)
    end
  end
end

# Create diverse subscription data for market analysis
users = User.all
base_date = Date.parse('2025-06-15')

# Use the helper method to create sample subscriptions
create_sample_subscriptions_for_market_analysis(users, default_user_email, base_date, categories)

total_subscriptions = Subscription.count
total_users = User.count
puts "Market analysis data seeded successfully!"
puts "Total users: #{total_users}"
puts "Total subscriptions: #{total_subscriptions}"
puts "Ready for market analysis testing."