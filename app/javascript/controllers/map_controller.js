import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "map", "enigmaModal" ]

  connect() {
    console.log("Map connected")
    this.displayMap();
    this.fetchVisitedTeamMarkers()
    this.fetchNextTeamMarker()
    // this.getLocation(); // Géolocalisation désactivée pour le moment


    // Exemple de marqueur pour les tests
    // L.marker([48.8049, 2.1204]).addTo(this.map)
    // .bindPopup('Un point d\'exemple.')
    // .openPopup();

    // L.circle([48.8049, 2.1204], {
    //   radius: 2000,
    //   color: 'red', // Couleur du contour du cercle
    //   fillColor: '#f03', // Couleur de remplissage
    //   fillOpacity: 0.5,
    //   zIndexOffset: 9999 // Ajuste ce z-index pour que le cercle soit au-dessus
    // }).addTo(this.map);

  }
  // fonction pour afficher la map avec un centrage sur Versailles
  displayMap() {
    const L = window.L;
    this.map = L.map(this.mapTarget).setView([48.8049, 2.1204], 17); // TODO : ici on devrait centrer la map sur la position de l'utilisateur
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(this.map);
  }

  // fonction pour afficher un marqueur sur la map
  displayMarker(markerCoordinates,nextTeamMarkerMessage) {
    const L = window.L;
    L.marker(markerCoordinates).addTo(this.map)
    .bindPopup(nextTeamMarkerMessage)
    // .openPopup(); // Popup fermé par défaut
  }

  // fonction pour récupérer le prochain point à visiter
  async fetchNextTeamMarker() {
    fetch('map/next_team_marker', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    })
      .then(response => response.json())
      .then(data => {
        // Traite les données du prochain point à visiter
        const nextTeamMarker = data.next_team_marker.marker_coordinates;
        const nextTeamMarkerMessage = data.next_team_marker.enigma;
        // this.displayMarker(nextTeamMarker,nextTeamMarkerMessage); // le marqueur n'est pas affiché sur la map
        this.enigmaModalTarget.innerText = nextTeamMarkerMessage; // Affiche l'énigme dans le modal

        L.circle(nextTeamMarker, {
          radius: 50,
          className: 'leaflet-circle-custom'
        }).addTo(this.map);

      });
  }

  // affichage des marqueurs déjà visités par l'équipe
  async fetchVisitedTeamMarkers() {
    fetch('map/visited_team_markers', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    })
      .then(response => response.json())
      .then(data => {
        // Traite les données des points déjà visités par l'équipe
        const visitedTeamMarkers = data.visited_team_markers;
        visitedTeamMarkers.forEach((visitedTeamMarker) => {
          this.displayMarker(visitedTeamMarker.marker_coordinates,visitedTeamMarker.name);
          console.log(visitedTeamMarker)
        });
      })

  }

  // fonction pour afficher un marqueur de géolocalisation de l'utilisateur
  getLocation() {
    if (navigator.geolocation) {
      this.watchId = navigator.geolocation.watchPosition(
        (position) => this.showPosition(position), // Utilise une fonction fléchée pour maintenir le contexte
        (error) => this.handleError(error) // Utilise une fonction fléchée pour maintenir le contexte
      );
    } else {
      console.error("Geolocation is not supported by this browser.");
    }
  }

  showPosition(position) {
    const { latitude, longitude } = position.coords;
    this.displayMarker([latitude, longitude], "Votre position actuelle");
    console.log(`Latitude: ${latitude}, Longitude: ${longitude}`);
  }

  handleError(error) {
    console.error(`Error occurred: ${error.message}`);
  }

  // créer une fonction pour recentrer la map sur la position de l'utilisateur

}
