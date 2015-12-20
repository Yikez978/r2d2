module API
  class SweepsController < ApplicationController
    def create
      sweep = Sweep.new(sweep_params)
      if sweep.save
        render json: sweep, status: 201
      else
        render json: sweep.errors, status: 422 # :unprocessable_entity
      end
    end
    
    private
      def sweep_params
        params.require(:sweep).permit(:description, nodes_attributes: [:mac, :ip])
      end
  end
end