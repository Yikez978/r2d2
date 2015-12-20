module API
  class NodesController < ApplicationController
    def index
      devices = Node.all
      render json: nodes
    end
    
    def show
      device = Device.find(params[:id])
      render json: node
    end

    def create
      node = Node.new(node_params)
      if node.save
        render json: node, status: 201
      else
        render json: node.errors, status: 422 # :unprocessable_entity
      end
    end
    
    private
      def node_params
        params.require(:node).permit(:mac, :ip)
      end
  end
end