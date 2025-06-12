class PagesController < ApplicationController
  def landing
    # Redirect authenticated users to their dashboard
    redirect_to subscriptions_summary_path if user_signed_in?
    
    render layout: 'application'
  end
end