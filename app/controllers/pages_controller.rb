class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:home]

  def home
  end

  # def map
  #   @markers = Marker.all
  # end

  def team
    @teams = Team.all
  end
end
