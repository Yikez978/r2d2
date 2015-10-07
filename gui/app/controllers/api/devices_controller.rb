module API
  class DevicesController < ApplicationController
    def index
      devices = Device.all
      render json: devices
    end
    
    def show
      device = Device.find(params[:id])
      render json: device
    end

    def create
      device = Device.new(device_params)
      if device.save
        render json: device, status: 201
      else
        render json: device.errors, status: 422 # :unprocessable_entity
      end
    end
    
    private
      def device_params
        params.require(:device).permit(:mac, :ip)
      end
  end
end