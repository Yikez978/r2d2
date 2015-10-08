class SweepsController < ApplicationController
  def index
    @sweeps = Sweep.paginate(page: params[:page])
  end
  def show
    @sweep = Sweep.find(params[:id])
    device_list = @sweep.devices
    @devices = device_list.paginate(page: params[:page])
  end
end
