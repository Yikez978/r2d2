module API
  class ScopesController < ApplicationController
    def index
      scopes = Scope.where("server_id = ?", params[:server_id])
      render json: scopes, status: 200
    end

    def show
      scope = Scope.find(params[:id])
      render json: { id: scope.id,
                     ip: scope.ip,
                     mask: scope.mask,
                     leasetime: scope.leasetime,
                     description: scope.description,
                     comment: scope.comment,
                     state: scope.state,
                     server_id: scope.server_id
                  }, status: 200
    end

    def update
      scope = Scope.find(params[:id])
      if scope.update(scope_params)
        render nothing: true, status: 204
      else
        render json: scope.errors, status: 422 # :unprocessable_entity
      end
    end
    
    private
      def scope_params
        params.require(:scope).permit(leases_attributes: [:id, :ip, :mask, :expiration, :kind, :name, :device_id ])
      end
  end
end
