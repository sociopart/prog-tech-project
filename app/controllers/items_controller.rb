class ItemsController < ApplicationController
load_and_authorize_resource
  # GET /items or /items.json
  def index
    @items = Item.all
    @item = Item.new
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:success] = 'Товар успешно создан'
    else
      flash[:danger] = 'Ошибка создания товара'
      redirect_to :back 
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
  
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy

  end

  private

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :description, :price, :user_id)
    end
end
