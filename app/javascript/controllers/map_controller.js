import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "map", "enigmaModal" ]

  connect() {
    console.log("Map connected")
    this.displayMap(); // affichage de la map

    // Affichage des marqueurs déjà visités par l'équipe
    // this.fetchVisitedTeamMarkers() // pour l'instant on affiche pas ces marqueurs

    // Récupère et affiche la position de l'utilisateur

    // Récupère le prochain point à visiter
    this.fetchNextTeamMarker().then(nextPoint => {
      if (nextPoint) {
        // Stocker la position du prochain point
        this.nextPoint = nextPoint;
        console.log(nextPoint)
        ; // Une méthode pour calculer la distance à ce point
      }
    });
    this.getLocation();




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
    // La position de Versailles est [48.8049, 2.1204], 17, j'ai modifié avec la mienne pour les tests
    this.map = L.map(this.mapTarget).setView([48.8701952, 2.3855104], 13); // TODO : ici on devrait centrer la map sur la position de l'utilisateur
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
try {
  const response = await fetch('map/next_team_marker', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    })

    if (!response.ok) {
      throw new Error("Failed to fetch next team marker.");
    }
    const data = await response.json();
    // Traite les données du prochain point à visiter
    const nextTeamMarker = data.next_team_marker.marker_coordinates;
    const nextTeamMarkerMessage = data.next_team_marker.enigma;

    // Affiche l'énigme dans la modal
    this.enigmaModalTarget.innerText = nextTeamMarkerMessage;

    L.circle(nextTeamMarker, {
      radius: 50,
      className: 'leaflet-circle-custom'
    }).addTo(this.map);

    // console.log(nextTeamMarker);
    return nextTeamMarker;

  } catch (error) {
    console.error('Error fetching the next team marker:', error);
    return null; // En cas d'erreur, retourne null ou une autre valeur par défaut
  }
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
          // console.log(visitedTeamMarker)
        });
      })

  }

  // fonction pour afficher et mettre à jour un marqueur de géolocalisation de l'utilisateur
  getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.watchPosition(this.updatePosition.bind(this), this.handleError.bind(this));
    } else {
      console.error("Geolocation is not supported by this browser.");
    }
  }

  createMarker(lat, lng) {
    // Création initiale du marqueur
    this.userMarker = L.marker([lat, lng], {
      icon: this.getUserLocationIcon() // Personnalisation de l'icône
    }).addTo(this.map);
  }

  updatePosition(position) {
    const { latitude, longitude } = position.coords;

    if (!this.userMarker) {
      this.createMarker(latitude, longitude); // Création initiale
    } else {
      this.userMarker.setLatLng([latitude, longitude]); // Mise à jour de la position
    }
    if (this.nextPoint) { // Si on ne connait pas encore le prochain point, on ne peut pas calculer la distance
      this.calculateDistanceToNextPoint(latitude,longitude)
    }
    // console.log(`Latitude: ${latitude}, Longitude: ${longitude}`);
  }

  getUserLocationIcon() {
    // Retourne l'icône personnalisée pour la localisation de l'utilisateur
    return L.divIcon({
      className: 'user-location-icon',
      iconSize: [30, 30] // Taille de l'icon, doit être aussi défini en css
    });
  }

  handleError(error) {
    console.error("Erreur de géolocalisation : ", error);
  }


// Méthode pour calculer la distance entre l'utilisateur et le prochain point
calculateDistanceToNextPoint(userLat, userLng) {
  const nextPointLat = this.nextPoint[0]; // Récupère les coordonnées du prochain point
  const nextPointLng = this.nextPoint[1];

  // Utilise la méthode distance de Leaflet pour calculer la distance en mètres
  const distance = L.latLng(userLat, userLng).distanceTo(L.latLng(nextPointLat, nextPointLng));

  // Afficher la distance en console ou l'afficher dans le DOM
  console.log(`Distance to next point: ${Math.round(distance)} meters`);

  // Optionnel : Mets à jour une valeur dans ton UI pour afficher la distance
  document.getElementById('distanceToNextPoint').innerText = `Next point: ${Math.round(distance)} m`;
}




  // créer une fonction pour recentrer la map sur la position de l'utilisateur

}
