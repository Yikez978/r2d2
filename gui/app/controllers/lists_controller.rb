class ListsController < ApplicationController
  def index
    @search = List.search(params[:q])
    @lists = @search.result.paginate(page: params[:page])
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

  def destroy
    @list = List.find(params[:id])
    Device.where(list: @list.id).update_all(list_id: List.find_by_name('Unassigned'))
    @list.destroy
    flash[:success] = "Deleted list named '#{@list.name}'."
    redirect_to lists_path
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
