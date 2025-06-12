class PagesController < ApplicationController
  def landing
    # Redirect authenticated users to their dashboard
    if user_signed_in?
      redirect_to summary_subscriptions_path
      return
    end
    
    render layout: 'application'
  end
end