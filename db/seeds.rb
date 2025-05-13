Subscription.destroy_all
Category.destroy_all

other         = Category.create!(name: "Other")
entertainment = Category.create!(name: "Entertainment")
housing     = Category.create!(name: "Housing")
utilities = Category.create!(name: "Utilities")

add_subscriptions = [
  {:name => 'Office365', :price => '12',
    :billing_cycle => 'Monthly', :next_payment_date => '25-May-2025', :category => other},
  {:name => 'Prime', :price => '5.99',
    :billing_cycle => 'Monthly', :next_payment_date => '25-Jun-2025', :category => entertainment}, 
  {:name => 'Rent', :price => '1000',
    :billing_cycle => 'Monthly', :next_payment_date => '25-May-2026', :category => housing},
  {:name => 'Internet', :price => '35',
    :billing_cycle => 'Monthly', :next_payment_date => '10-May-2025', :category => utilities},
  {:name => 'Mobile', :price => '25',
    :billing_cycle => 'Monthly', :next_payment_date => '18-May-2025', :category => utilities},
  {:name => 'Spotify Premium', :price => '5',
    :billing_cycle => 'Monthly', :next_payment_date => '28-May-2025', :category => entertainment},
  {:name => 'PS Plus', :price => '12',
    :billing_cycle => 'Monthly', :next_payment_date => '29-May-2025', :category => entertainment}, 
  {:name => 'Magazine Subscription', :price => '15',
    :billing_cycle => 'Yearly', :next_payment_date => '22-May-2026', :category => entertainment},
  {:name => 'Google Storage', :price => '12',
    :billing_cycle => 'Yearly', :next_payment_date => '2-May-2025', :category => other},
  {:name => 'Netflix', :price => '15',
    :billing_cycle => 'Monthly', :next_payment_date => '16-May-2025', :category => entertainment}
]

add_subscriptions.each do |subscription|
    Subscription.create!(subscription)
end