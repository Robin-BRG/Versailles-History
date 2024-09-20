class MapsController < ApplicationController

  def show
    @markers = Marker.all
  end
end
