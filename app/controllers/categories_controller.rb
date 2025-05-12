class CategoriesController < ApplicationController
  def index
    @categories = Category.alphabetical
  end
end
