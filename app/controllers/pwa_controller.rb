class PwaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def manifest
    respond_to { |format| format.json }
  end
end
