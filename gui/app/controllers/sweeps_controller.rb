class SweepsController < ApplicationController
  def index
    @sweeps = Sweep.paginate(page: params[:page])
  end
  def show
    device_list = Sweep.find(params[:id]).devices
    @devices = device_list.paginate(page: params[:page])
  end
end
