class MainController < ApplicationController
  before_action :authenticate_user!
  def index
    @items = Item.all
    @item = Item.new
  end
end