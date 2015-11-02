class DevicesController < ApplicationController
  def index
    @devices = Device.paginate(page: params[:page])
  end
  def show
    @device = Device.find(params[:id])
    d = Sweep.includes(:devices).where(devices:{mac: @device.mac})
    @details = d.paginate(page: params[:page])
  end
  def update
    device = Device.find(params[:id])
    if params[:status].empty?
      params[:status] = nil
    end
    device.status = params[:status]
    device.save
    redirect_to '/r2d2'
  end
end
