# app/services/market_analysis_service.rb
class MarketAnalysisService
  def initialize(subscription)
    @subscription = subscription
    @user = subscription.user
  end

  def analyze
    {
      subscription_info: subscription_info,
      price_comparison: price_comparison_data,
      billing_cycle_analysis: billing_cycle_analysis,
      category_insights: category_insights,
      savings_opportunities: savings_opportunities,
      alternative_suggestions: alternative_suggestions
    }
  end

  private

  attr_reader :subscription, :user
  def subscription_info
    {
      name: subscription.name,
      current_price: subscription.price,
      billing_cycle: subscription.billing_cycle,
      category: subscription.category&.name || 'Uncategorized',
      monthly_equivalent: monthly_equivalent_price,
      billing_cycle_equivalent: billing_cycle_equivalent
    }
  end

  def price_comparison_data
    similar_subscriptions = find_similar_subscriptions
    
    return no_comparison_data if similar_subscriptions.empty?

    prices = similar_subscriptions.pluck(:price)
    same_cycle_prices = similar_subscriptions.where(billing_cycle: subscription.billing_cycle).pluck(:price)
    
    {
      total_users: similar_subscriptions.count,
      same_cycle_users: same_cycle_prices.count,
      average_price: prices.sum.to_f / prices.count,
      median_price: calculate_median(prices),
      your_price: subscription.price.to_f,
      percentile: calculate_percentile(prices, subscription.price.to_f),
      same_cycle_average: same_cycle_prices.any? ? same_cycle_prices.sum.to_f / same_cycle_prices.count : nil,
      price_range: { min: prices.min, max: prices.max }
    }
  end

  def billing_cycle_analysis
    service_subscriptions = find_similar_subscriptions
    
    monthly_subs = service_subscriptions.where(billing_cycle: 'Monthly')
    yearly_subs = service_subscriptions.where(billing_cycle: 'Yearly')
    
    return no_billing_analysis if monthly_subs.empty? && yearly_subs.empty?

    {
      monthly: {
        count: monthly_subs.count,
        average_price: monthly_subs.any? ? monthly_subs.average(:price).to_f : nil,
        median_price: monthly_subs.any? ? calculate_median(monthly_subs.pluck(:price)) : nil
      },
      yearly: {
        count: yearly_subs.count,
        average_price: yearly_subs.any? ? yearly_subs.average(:price).to_f : nil,
        median_price: yearly_subs.any? ? calculate_median(yearly_subs.pluck(:price)) : nil,
        monthly_equivalent: yearly_subs.any? ? yearly_subs.average(:price).to_f / 12 : nil
      }
    }
  end

  def category_insights
    return {} unless subscription.category

    category_subs = Subscription.joins(:user)
                               .where(category: subscription.category)
                               .where.not(user: user)

    return no_category_data if category_subs.empty?

    monthly_subs = category_subs.where(billing_cycle: 'Monthly')
    yearly_subs = category_subs.where(billing_cycle: 'Yearly')

    {
      category_name: subscription.category.name,
      total_users: category_subs.select(:user_id).distinct.count,
      average_monthly_spend: monthly_subs.any? ? monthly_subs.average(:price).to_f : 0,
      average_yearly_spend: yearly_subs.any? ? yearly_subs.average(:price).to_f : 0,
      popular_services: category_subs.group(:name).order('count_id DESC').limit(5).count(:id),
      user_category_total: user_category_spending
    }
  end

  def savings_opportunities
    opportunities = []
    billing_analysis = billing_cycle_analysis

    # Check if switching billing cycles could save money
    if subscription.billing_cycle == 'Monthly' && billing_analysis[:yearly][:monthly_equivalent]
      yearly_equivalent = billing_analysis[:yearly][:monthly_equivalent]
      if yearly_equivalent < subscription.price.to_f
        annual_savings = (subscription.price.to_f - yearly_equivalent) * 12
        opportunities << {
          type: 'billing_cycle',
          description: "Switch to yearly billing",
          potential_savings: annual_savings,
          details: "You could save approximately $#{annual_savings.round(2)} per year by switching to yearly billing"
        }
      end
    elsif subscription.billing_cycle == 'Yearly' && billing_analysis[:monthly][:average_price]
      monthly_equivalent = billing_analysis[:monthly][:average_price] * 12
      if monthly_equivalent < subscription.price.to_f
        annual_savings = subscription.price.to_f - monthly_equivalent
        opportunities << {
          type: 'billing_cycle',
          description: "Switch to monthly billing",
          potential_savings: annual_savings,
          details: "You could save approximately $#{annual_savings.round(2)} per year by switching to monthly billing"
        }
      end
    end

    # Check if user is paying significantly above average
    price_data = price_comparison_data
    if price_data[:percentile] && price_data[:percentile] > 75
      opportunities << {
        type: 'price_optimization',
        description: "You're paying above average",
        potential_savings: subscription.price.to_f - price_data[:average_price],
        details: "You're paying more than #{price_data[:percentile].round}% of other users. Consider negotiating or looking for alternatives."
      }
    end

    opportunities
  end
  def alternative_suggestions
    return [] unless subscription.category

    # Find other popular services in the same category
    category_services = Subscription.where(category: subscription.category)
                                  .where.not(name: subscription.name)
                                  .where.not(user: user)
                                  .group(:name)
                                  .having('count(*) >= 2') # Only suggest services used by multiple users
                                  .order(Arel.sql('count(*) DESC'))
                                  .limit(3)
                                  .pluck(:name)

    category_services.map do |name|
      service_subs = Subscription.where(name: name, category: subscription.category)
      {
        name: name,
        user_count: service_subs.count,
        average_price: service_subs.average(:price).to_f,
        billing_cycles: service_subs.distinct.pluck(:billing_cycle)
      }
    end
  end

  def find_similar_subscriptions
    @similar_subscriptions ||= Subscription.where(name: subscription.name)
                                          .where.not(user: user)
  end
  def monthly_equivalent_price
    case subscription.billing_cycle
    when 'Monthly'
      subscription.price.to_f
    when 'Yearly'
      subscription.price.to_f / 12
    else
      subscription.price.to_f
    end
  end

  def billing_cycle_equivalent
    {
      equivalent_price: case subscription.billing_cycle
                       when 'Monthly'
                         subscription.price.to_f * 12  # Show yearly equivalent
                       when 'Yearly'
                         subscription.price.to_f / 12  # Show monthly equivalent
                       else
                         subscription.price.to_f
                       end,
      equivalent_cycle: case subscription.billing_cycle
                       when 'Monthly'
                         'Yearly'
                       when 'Yearly'
                         'Monthly'
                       else
                         subscription.billing_cycle
                       end
    }
  end

  def user_category_spending
    return 0 unless subscription.category

    user.subscriptions.where(category: subscription.category).sum do |sub|
      case sub.billing_cycle
      when 'Monthly'
        sub.price * 12 # Convert to yearly
      when 'Yearly'
        sub.price
      else
        sub.price
      end
    end
  end

  def calculate_median(prices)
    return 0 if prices.empty?
    
    sorted = prices.sort
    length = sorted.length
    
    if length.odd?
      sorted[length / 2].to_f
    else
      (sorted[length / 2 - 1] + sorted[length / 2]) / 2.0
    end
  end

  def calculate_percentile(prices, target_price)
    return nil if prices.empty?
    
    below_count = prices.count { |price| price < target_price }
    (below_count.to_f / prices.length * 100).round(1)
  end

  def no_comparison_data
    {
      total_users: 0,
      same_cycle_users: 0,
      message: "No other users have this subscription for comparison"
    }
  end

  def no_billing_analysis
    {
      monthly: { count: 0 },
      yearly: { count: 0 },
      message: "Insufficient data for billing cycle analysis"
    }
  end

  def no_category_data
    {
      message: "No category data available for comparison"
    }
  end
end
