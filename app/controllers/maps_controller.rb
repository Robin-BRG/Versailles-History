class MapsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :next_team_marker]
  def show
    @markers = Marker.all
  end

  def next_team_marker
    # team_id = params[:team_id] # Récupération du paramètre team_id
    # TODO ajouter un contrôle de présence du paramètre team_id
    # Marker de test
    @next_team_marker = {
      marker_coordinates: [48.804865, 2.126614],
      circle_coordinates: [48.8049, 2.1204],
      enigma: "Quelle est la capitale de la France ?"
    }

    # cette requete devrait retourner le prochain marker non visité de l'équipe
    # @next_team_marker = TeamMarker.joins(:marker) # Jointure avec la table 'markers'
    #                               .select('marker.latitude, marker.longitude, marker.enigma') # Sélection des champs souhaités de 'markers'
    #                               .where(team_id: team_id, visited: false) # Conditions sur le team_id et le statut visited
    #                               .order(:order) # Trier par le champ 'order'
    #                               .first

    render json: { next_team_marker: @next_team_marker }
  end
end
