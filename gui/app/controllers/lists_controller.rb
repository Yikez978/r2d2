class ListsController < ApplicationController
  def index
    @lists = List.paginate(page: params[:page])
  end

  def edit
    @list = List.find(params[:id])
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if @list.save
      flash[:success] = "Added new list #{@list.name}"
      redirect_to lists_path
    else
      flash[:danger] = 'Error'
      render 'new'
    end
    
  end

  def update
    @list = List.find(params[:id])
    if @list.update_attributes(list_params)
      flash[:success] = "List updated"
      redirect_to lists_path
    else
      render 'edit'
    end
  end
  
  private
    def list_params
      params.require(:list).permit(:name)
    end
end
