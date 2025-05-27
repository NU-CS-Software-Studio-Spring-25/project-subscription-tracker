class ErrorsController < ApplicationController
  layout "application"
  
  def not_found
    render status: :not_found  # 404
  end

  def internal_server_error
    render status: :internal_server_error  # 500
  end
end
