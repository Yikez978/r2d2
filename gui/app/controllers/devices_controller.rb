class DevicesController < ApplicationController
  def index
    @devices = Device.paginate(page: params[:page])
  end
  def show
    @device = Device.find(params[:id])
    d = Sweep.includes(:devices).where(devices:{mac: @device.mac})
    @details = d.paginate(page: params[:page])
  end
end
