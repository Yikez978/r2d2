class LeasesController < ApplicationController
  def index
    @search = Lease.search(params[:q])
    @leases = @search.result.includes(:device, scope:[:server]).paginate(page: params[:page])

#    @leases = Lease.includes(scope:[:server]).paginate(page: params[:page])
  end

  def show
    @lease = Lease.includes(scope:[:server]).find(params[:id])
  end
end
