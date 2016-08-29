module API
  class ServersController < ApplicationController
    def index
      render json: Server.all.select("id, ip, name"), status: 200
    end

    def show
      server = Server.find(params[:id])
      render json: {id: server.id, ip: server.ip, name: server.name}, status: 200
    end

    def update
      server = Server.find(params[:id])
      if server.update(server_params)
        render json: server, status: 200
      else
        render json: server.errors, status: 422 # :unprocessable_entity
      end
    end
    
    private
      def server_params
        params.require(:server).permit(scopes_attributes: [:id, :leasetime, :comment, :ip, :description, :state, :mask ])
      end
  end
end
