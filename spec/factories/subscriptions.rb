FactoryBot.define do
  factory :subscription do
    association :user
    association :category
    name { 'Test Subscription' }
    price { 10.99 }
    billing_cycle { 'Monthly' }
    next_payment_date { 1.month.from_now }
    notification_days_before { 3 }
  end
end