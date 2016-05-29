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
  end

  def create
  end

  def destroy
  end
end
