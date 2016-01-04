class MenusController < ApplicationController
  def index
  	@menus = Menu.all
  end

  def show
    @menu = Menu.find(params[:id])
    @subset_items = @menu.item_subset
  end

  def new
  	@menu = Menu.new
  end

  def create
  	@menu = Menu.new(menu_params)

  	if @menu.save
  		redirect_to '/menus'
  	else
  		render 'new'
  	end
  end

  private

 	def menu_params
 		params.require(:menu).permit(:name, :menu_file)
 	end

end
