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

  def visited_team_markers
    visited_team_markers = TeamMarker.where(team_id: current_user.team_id, visited: true).order(:order)
    visited_markers_data = visited_team_markers.map do |team_marker|
      marker = Marker.find(team_marker.marker_id)
      {
        marker_coordinates: [marker.latitude, marker.longitude],
        # circle_coordinates: [team_marker.circle_center_latitude, team_marker.circle_center_longitude],
        # enigma: marker.enigma
      }
    end
    render json: { visited_team_markers: visited_markers_data }
  end


end
