class LeasesController < ApplicationController
  def show
    @lease = Lease.includes(scope:[:server]).find(params[:id])
  end
end
