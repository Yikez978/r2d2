class SweepersController < ApplicationController
  def index
    @sweepers = Sweeper.paginate(page: params[:page])
  end

  def edit
  end

  def show
    @sweeper = Sweeper.find(params[:id])
    s = Sweep.includes(:nodes).where(nodes:{mac:@sweeper.mac})
    @sweeps = s.paginate(page: params[:page])
  end

  def update
  end

  def new
    @sweeper = Sweeper.new
  end

  def create
    @sweeper = Sweeper.new(list_params)
    if @sweeper.save
      flash[:success] = "Added new sweeper #{@sweeper.mac}"
      redirect_to sweepers_path
    else
      flash[:danger] = 'Error'
      render 'new'
    end
    
  end

  def destroy
  end
  private
    def list_params
      params.require(:sweeper).permit(:mac, :ip, :description)
    end
end
