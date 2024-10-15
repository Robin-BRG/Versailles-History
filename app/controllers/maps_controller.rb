class MapsController < ApplicationController
  before_action :authenticate_user!
  def show

  end

  def next_team_marker
    # Récupération du prochain team_marker à visiter
    next_team_marker = TeamMarker.where(team_id: current_user.team_id, visited: false).order(:order).first
    # TODO : gérer le cas ou tous les team markers ont été visités
    # Récupération du marker associé
    if next_team_marker
      next_marker = Marker.find(next_team_marker.marker_id)
      team_marker_id = next_team_marker.id
      is_last_marker = false
      circle_coordinates = [next_team_marker.circle_center_latitude, next_team_marker.circle_center_longitude]
    else
      next_marker = Marker.find_by(name: "Hôtel Le Louis")
      is_last_marker = true
      circle_coordinates = [next_marker.latitude, next_marker.longitude]
      team_marker_id = nil
    end


    # Mise en forme des données pour le front
    @next_team_marker_data = {
      marker_coordinates: [next_marker.latitude, next_marker.longitude],
      circle_coordinates:,
      enigma: next_marker.enigma,
      team_marker_id:,
      is_last_marker:
    }

    render json: { next_team_marker: @next_team_marker_data }
  end

  def visited_team_markers
    visited_team_markers = TeamMarker.where(team_id: current_user.team_id, visited: true).order(:order)
    visited_markers_data = visited_team_markers.map do |team_marker|
      marker = Marker.find(team_marker.marker_id)
      {
        marker_coordinates: [marker.latitude, marker.longitude],
        name: marker.name,
        content: marker.content
        # circle_coordinates: [team_marker.circle_center_latitude, team_marker.circle_center_longitude],
        # enigma: marker.enigma
      }
    end
    render json: { visited_team_markers: visited_markers_data }
  end

  def validate
    marker = TeamMarker.find(params[:id])
    if marker.update!(visited: true)
      render json: { success: true }
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  def raz
    TeamMarker.where(team_id: current_user.team_id).update_all(visited: false)
    render json: { success: true }
  end

end
