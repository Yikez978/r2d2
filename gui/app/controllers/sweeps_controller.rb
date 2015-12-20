class SweepsController < ApplicationController
  def index
    @sweeps = Sweep.paginate(page: params[:page])
  end
  def show
    @sweep = Sweep.find(params[:id])
    node_list = @sweep.nodes
    @nodes = node_list.paginate(page: params[:page])
  end
end
