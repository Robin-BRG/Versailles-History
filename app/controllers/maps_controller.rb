class MapsController < ApplicationController
  before_action :authenticate_user!
  def show

  end

  def next_team_marker
    # Récupération du prochain team_marker à visiter
    next_team_marker = TeamMarker.where(team_id: current_user.team_id, visited: false).order(:order).first

    # s'il y a un next team marqueur on continue
    if next_team_marker
      next_marker = Marker.find(next_team_marker.marker_id)
      team_marker_id = next_team_marker.id
      is_last_marker = false
      circle_coordinates = [next_team_marker.circle_center_latitude, next_team_marker.circle_center_longitude]
      if next_marker.name == "Hôtel Le Louis"
        # si le next team marqueur est l'hotel on le passe à validé
        TeamMarker.where(team_id: current_user.team_id, visited: false).order(:order).update!(visited: true)
        is_last_marker = true
      end
    else # s'il n'y a pas de next team marqueur on créé quand même des données à envoyer à l'API
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
