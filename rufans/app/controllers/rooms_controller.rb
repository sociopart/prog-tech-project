class RoomsController < ApplicationController
  before_action :set_current_user_for_action_cable, only: [:show]
  
  def index
    @rooms = Room.all
  end
  
  def show
    @room = Room.find_by(id: params[:id])
    @message = Message.new room: @room
  end
end