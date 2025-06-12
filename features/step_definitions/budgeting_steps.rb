Given('I have the following subscriptions:') do |table|
  table.hashes.each do |row|
    category = Category.find_by(name: row['category'])
    FactoryBot.create(:subscription,
      user: @user,
      name: row['name'],
      category: category,
      price: row['price'].to_f,
      billing_cycle: row['billing_cycle'],
      next_payment_date: 1.month.from_now
    )
  end
end

Given('I am on the budgeting page') do
  visit budgeting_categories_path
end

When('I set a monthly budget of {string} for {string}') do |amount, category_name|
  # Use a more specific selector or find the first matching card
  within all('.card').find { |card| card.has_content?(category_name) } do
    fill_in 'amount', with: amount
    click_button 'Update'
  end
end

When('I try to set a budget of {string} for {string}') do |amount, category_name|
  # Use a more specific selector or find the first matching card
  within all('.card').find { |card| card.has_content?(category_name) } do
    fill_in 'amount', with: amount
    click_button 'Update'
  end
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should see {string} for {word}') do |amount_text, category_name|
  # Find the specific card containing the category name
  within all('.card').find { |card| card.has_content?(category_name) } do
    expect(page).to have_content(amount_text)
  end
end

Then('no budget should be set for {word}') do |category_name|
  category = Category.find_by(name: category_name)
  expect(category.budgets.where(user: @user)).to be_empty
end