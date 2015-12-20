class NodesController < ApplicationController
  def show
    @node = Node.find(params[:id])
    s = Sweep.includes(:nodes).where(nodes:{mac:@node.mac})
    @sweeps = s.paginate(page: params[:page])
  end
end