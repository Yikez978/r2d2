class ListsController < ApplicationController
  def index
    @lists = List.paginate(page: params[:page])
  end

  def edit
    @list = List.find(params[:id])
  end
  
  def update
    @list = List.find(params[:id])
    if @list.update_attributes(list_params)
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
