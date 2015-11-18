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
    if params[:list].empty?
      params[:list] = List.find_by_name('Unassigned')
    end
    device.list = List.find(params[:list])
    device.save
    redirect_to :back
  end
end
