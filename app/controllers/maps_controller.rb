class MapsController < ApplicationController
  before_action :authenticate_user!
  def show
    @markers = Marker.all
  end

  def next_team_marker
    # Récupération du prochain team_marker à visiter
    next_team_marker = TeamMarker.where(team_id: current_user.team_id, visited: false).order(:order).first
    # Récupération du marker associé
    next_marker = Marker.find(next_team_marker.marker_id)

    # Mise en forme des données pour le front
    @next_team_marker_data = {
      marker_coordinates: [next_marker.latitude, next_marker.longitude],
      circle_coordinates: [next_team_marker.circle_center_latitude, next_team_marker.circle_center_longitude],
      enigma: next_marker.enigma
      }

    render json: { next_team_marker: @next_team_marker_data }
  end
end
