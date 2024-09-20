import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "map" ]

  connect() {
    console.log("Map connected")
    const teamId = 1; // TODO: Récupérer l'id de l'équipe pour le pousser à l'API
    this.displayMap();
    this.fetchNextTeamMarker(teamId)

    // Exemple de marqueur pour les tests
    L.marker([48.8049, 2.1204]).addTo(this.map)
    .bindPopup('Un point d\'exemple.')
    .openPopup();

  }
  // fonction pour afficher la map avec un centrage sur Versailles
  displayMap() {
    const L = window.L;
    this.map = L.map(this.mapTarget).setView([48.8049, 2.1204], 14);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(this.map);
  }

  // fonction pour afficher un marqueur sur la map
  displayMarker(markerCoordinates,nextTeamMarkerMessage) {
    const L = window.L;
    L.marker(markerCoordinates).addTo(this.map)
    .bindPopup(nextTeamMarkerMessage) // si on veut ajouter un popup il faudra le passer en paramètre
    .openPopup();
  }

  // fonction pour récupérer le prochain point à visiter
  async fetchNextTeamMarker(teamId) {
    fetch('map/next_team_marker', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ team_id: teamId }) // Envoie team_id dans le body
    })
      .then(response => response.json())
      .then(data => {
        // Traite les données du prochain point à visiter
        const nextTeamMarker = data.next_team_marker.marker_coordinates;
        const nextTeamMarkerMessage = data.next_team_marker.enigma;
        this.displayMarker(nextTeamMarker,nextTeamMarkerMessage);
      });
  }

}
