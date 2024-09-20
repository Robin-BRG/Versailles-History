class MapsController < ApplicationController
  def show
    @markers = Marker.all
  end

  def next_team_marker(team_id)
    # Marker de test
    @next_team_marker = {
      latitude: 48.8049,
      longitude: 2.1204,
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
