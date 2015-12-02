class ListsController < ApplicationController
  def index
    @lists = List.paginate(page: params[:page])
  end
end
