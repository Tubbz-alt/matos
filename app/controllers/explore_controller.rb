class ExploreController < ApplicationController

  def index
    @maxZoomLevel = (can? :manage, Receiver) ? 20 : 10
  end

end
