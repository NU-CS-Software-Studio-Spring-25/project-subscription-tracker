#!/usr/bin/env ruby

# Test script to verify billing cycle equivalent functionality
# Run this with: ruby test_billing_cycle_equivalent.rb

# Add the Rails environment
require_relative 'config/environment'

puts "Testing Billing Cycle Equivalent Feature"
puts "=" * 50

# Find a monthly subscription
monthly_sub = Subscription.where(billing_cycle: 'Monthly').first
if monthly_sub
  puts "\nTesting MONTHLY subscription: #{monthly_sub.name}"
  puts "Current price: $#{monthly_sub.price} (Monthly)"
  
  service = MarketAnalysisService.new(monthly_sub)
  analysis = service.analyze
  
  equiv = analysis[:subscription_info][:billing_cycle_equivalent]
  puts "Equivalent cycle: #{equiv[:equivalent_cycle]}"
  puts "Equivalent price: $#{equiv[:equivalent_price]}"
  puts "Expected: Should show 'Yearly' and price * 12 = $#{monthly_sub.price * 12}"
  
  if equiv[:equivalent_cycle] == 'Yearly' && equiv[:equivalent_price] == monthly_sub.price * 12
    puts "✅ MONTHLY subscription test PASSED"
  else
    puts "❌ MONTHLY subscription test FAILED"
  end
else
  puts "❌ No monthly subscriptions found"
end

# Find a yearly subscription
yearly_sub = Subscription.where(billing_cycle: 'Yearly').first
if yearly_sub
  puts "\nTesting YEARLY subscription: #{yearly_sub.name}"
  puts "Current price: $#{yearly_sub.price} (Yearly)"
  
  service = MarketAnalysisService.new(yearly_sub)
  analysis = service.analyze
  
  equiv = analysis[:subscription_info][:billing_cycle_equivalent]
  puts "Equivalent cycle: #{equiv[:equivalent_cycle]}"
  puts "Equivalent price: $#{equiv[:equivalent_price]}"
  puts "Expected: Should show 'Monthly' and price / 12 = $#{yearly_sub.price / 12}"
  
  if equiv[:equivalent_cycle] == 'Monthly' && equiv[:equivalent_price] == yearly_sub.price / 12
    puts "✅ YEARLY subscription test PASSED"
  else
    puts "❌ YEARLY subscription test FAILED"
  end
else
  puts "❌ No yearly subscriptions found"
end

puts "\n" + "=" * 50
puts "Billing Cycle Equivalent Test Complete"
