Given('I am a registered user') do
  @user = FactoryBot.create(:user, email: 'test@example.com', password: 'password123')
end

Given('I am logged in') do
  visit new_user_session_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: 'password123'
  click_button 'Log in'
end

Given('the following categories exist:') do |table|
  table.hashes.each do |row|
    FactoryBot.create(:category, name: row['name'])
  end
end

Given('I am on the subscriptions page') do
  visit subscriptions_path
end

When('I click {string}') do |button_text|
  click_button button_text
end

When('I fill in the subscription form with:') do |table|
  table.hashes.each do |row|
    field = row['field']
    value = row['value']
    
    case field
    when 'Name'
      fill_in 'subscription_name', with: value if value.present?
    when 'Category'
      select value, from: 'subscription_category_id' if value.present?
    when 'Price'
      fill_in 'subscription_price', with: value if value.present?
    when 'Billing cycle'
      select value, from: 'subscription_billing_cycle' if value.present?
    when 'Next payment date'
      fill_in 'subscription_next_payment_date', with: value if value.present?
    when 'Notify (days before)'
      fill_in 'subscription_notification_days_before', with: value if value.present?
    end
  end
end

Then('I should see {string} in the subscriptions list') do |text|
  expect(page).to have_content(text)
end

Then('I should see {string} in the subscription details') do |text|
  expect(page).to have_content(text)
end

Then('I should see validation errors') do
  # Check for Bootstrap validation classes or alert messages
  has_error_alert = page.has_css?('.alert-danger')
  has_invalid_fields = page.has_css?('.is-invalid')
  has_error_text = page.has_content?('Please fix')
  
  expect(has_error_alert || has_invalid_fields || has_error_text).to be true
end