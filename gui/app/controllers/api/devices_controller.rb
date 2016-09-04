module API
  class DevicesController < ApplicationController
    def show
      device = Device.find_by mac: params[:id] # actually the MAC
      if device
        render json: { id: device.id, mac: device.mac }, status: 200
      else
        device = Device.new(mac: params[:id])
        if device.save
          render json: { id: device.id, mac: device.mac }, status: 201
        else
          render json: device.errors, status: 422 # :unprocessable_entity
        end
      end
    end
  end
end