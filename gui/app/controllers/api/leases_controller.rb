module API
  class LeasesController < ApplicationController
    def index
      leases = Lease.where("scope_id = ?", params[:scope_id])
      render json: leases, status: 200
    end
  end
end
