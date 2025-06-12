puts "Testing billing cycle equivalent functionality..."

# Test Monthly subscription
monthly_sub = Subscription.where(billing_cycle: 'Monthly').first
if monthly_sub
  puts "\n=== MONTHLY SUBSCRIPTION TEST ==="
  puts "Subscription: #{monthly_sub.name}"
  puts "Current price: $#{monthly_sub.price}/month"
  
  service = MarketAnalysisService.new(monthly_sub)
  analysis = service.analyze
  equiv = analysis[:subscription_info][:billing_cycle_equivalent]
  
  puts "Equivalent cycle: #{equiv[:equivalent_cycle]}"
  puts "Equivalent price: $#{equiv[:equivalent_price]}"
  puts "Expected: Should show 'Yearly' and $#{monthly_sub.price * 12}"
  
  if equiv[:equivalent_cycle] == 'Yearly' && equiv[:equivalent_price] == (monthly_sub.price * 12).to_f
    puts "✅ MONTHLY test PASSED"
  else
    puts "❌ MONTHLY test FAILED"
  end
end

# Test Yearly subscription
yearly_sub = Subscription.where(billing_cycle: 'Yearly').first
if yearly_sub
  puts "\n=== YEARLY SUBSCRIPTION TEST ==="
  puts "Subscription: #{yearly_sub.name}"
  puts "Current price: $#{yearly_sub.price}/year"
  
  service = MarketAnalysisService.new(yearly_sub)
  analysis = service.analyze
  equiv = analysis[:subscription_info][:billing_cycle_equivalent]
  
  puts "Equivalent cycle: #{equiv[:equivalent_cycle]}"
  puts "Equivalent price: $#{equiv[:equivalent_price]}"
  puts "Expected: Should show 'Monthly' and $#{yearly_sub.price / 12}"
  
  if equiv[:equivalent_cycle] == 'Monthly' && equiv[:equivalent_price] == (yearly_sub.price / 12).to_f
    puts "✅ YEARLY test PASSED"
  else
    puts "❌ YEARLY test FAILED"
  end
end

puts "\nTest complete!"
