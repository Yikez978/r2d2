class SweepersController < ApplicationController
  def index
    @sweepers = Sweeper.paginate(page: params[:page])
  end

  def edit
    @sweeper = Sweeper.find(params[:id])
  end

  def show
    @sweeper = Sweeper.find(params[:id])
    s = Sweep.includes(:nodes).where(nodes:{mac:@sweeper.mac})
    @sweeps = s.paginate(page: params[:page])
  end

  def update
    @sweeper = Sweeper.find(params[:id])
    if @sweeper.update_attributes(sweeper_params)
      flash[:success] = "Sweeper updated."
      redirect_to sweepers_path
    else
      render 'edit'
    end
  end

  def new
    @sweeper = Sweeper.new
  end

  def create
    @sweeper = Sweeper.new(sweeper_params)
    if @sweeper.save
      flash[:success] = "Added new sweeper #{@sweeper.mac}"
      redirect_to sweepers_path
    else
      flash[:danger] = 'Error'
      render 'new'
    end
    
  end

  def destroy
    @sweeper = Sweeper.find(params[:id])
    #Device.where(sweeper: @sweeper.id).update_all(list_id: List.find_by_name('Unassigned'))
    @sweeper.destroy
    flash[:success] = "Deleted sweeper with description '#{@sweeper.description}'."
    redirect_to sweepers_path
  end
  private
    def sweeper_params
      params.require(:sweeper).permit(:mac, :ip, :description)
    end
end
