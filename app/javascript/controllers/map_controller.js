import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "map", "enigmaModal", "recenterButton", "checkModalBody", "checkModalTitle" ]



  connect() {

    console.log("Map connected")
    this.initializeMap(); // affichage de la map

    // Affichage des marqueurs déjà visités par l'équipe
    this.fetchVisitedTeamMarkers() // pour l'instant on affiche pas ces marqueurs

    // Récupère et affiche la position de l'utilisateur
    this.getLocation();

    // Récupère le prochain point à visiter
    this.fetchNextTeamMarker().then(nextPoint => {
      if (nextPoint) {
        // Stocker la position du prochain point
        this.nextPoint = nextPoint;
        // console.log('Next point:', nextPoint.enigma);
      }
    });


    // Exemple de marqueur pour les tests
    // L.marker([48.8049, 2.1204]).addTo(this.map)
    // .bindPopup('Un point d\'exemple.')
    // .openPopup();

    // L.circle([48.7982, 2.12427], {
    //   radius: 50,
    //   color: 'red', // Couleur du contour du cercle
    //   fillColor: '#f03', // Couleur de remplissage
    //   fillOpacity: 0.5,
    // }).addTo(this.map);

  }
  // fonction initialiser la map avec un centrage sur Versailles
  initializeMap() {
    const L = window.L;
    // La position de Nation est [48.8701952, 2.3855104], 13
    //Next Point 48.7982, 2.12427
    // La position de Versailles est [48.8049, 2.1204], 17, j'ai modifié avec la mienne pour les tests
    this.map = L.map(this.mapTarget).setView([48.8049, 2.1204], 15); // TODO : ici on devrait centrer la map sur la position de l'utilisateur
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(this.map);


    this.markers = []; // créé un array vide pour stocker les marqueurs
    this.circle = null; // Initialisation du cercle à null
  }

  // fonctions pour ajouter un marqueur ou un cercle sur la map
  addMarker(coordinates, message) {
    const marker = L.marker(coordinates).addTo(this.map)
    .bindPopup(message);
    this.markers.push(marker); // Stocke le marqueur
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

    // Affiche l'énigme dans la modal
    this.enigmaModalTarget.innerText = data.next_team_marker.enigma;

    // On créé un cercle de centre NextTeamMarker mais on ne l'affiche pas sur la carte

      this.circle = L.circle(data.next_team_marker.circle_coordinates, {
      radius: 50,
      className: 'leaflet-circle-custom'
    });

    return data.next_team_marker;

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
          this.addMarker(visitedTeamMarker.marker_coordinates,visitedTeamMarker.name);
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
    this.userLat = position.coords.latitude;
    this.userLng = position.coords.longitude;

    if (!this.userMarker) {
      this.createMarker(this.userLat, this.userLng); // Création initiale
    } else {
      this.userMarker.setLatLng([this.userLat, this.userLng]); // Mise à jour de la position
    }
    if (this.nextPoint) { // Si on ne connait pas encore le prochain point, on ne peut pas calculer la distance
      this.calculateDistanceToNextPoint(this.userLat,this.userLng)
    }
    // console.log(`Latitude: ${this.userLat}, Longitude: ${this.userLng}`);
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
    // console.log('Calculating distance to next point');
    const nextPointLat = this.nextPoint.marker_coordinates[0]; // Récupère les coordonnées du prochain point
    const nextPointLng = this.nextPoint.marker_coordinates[1];

    // Utilise la méthode distance de Leaflet pour calculer la distance en mètres
    const distance = L.latLng(userLat, userLng).distanceTo(L.latLng(nextPointLat, nextPointLng));

    if (distance < 50000) { // si l'utilisateur est à moins de 50m du prochain point on affiche le cercle

        // Si le cercle n'est pas déjà ajouté à la carte, l'ajouter
        if (!this.circle._map) {
          this.circle.addTo(this.map);
        }
      } else {
        // Si l'utilisateur s'éloigne, retirer le cercle de la carte
        if (this.circle._map) {
          this.map.removeLayer(this.circle);
        }
      }

    // TODO retirer cette partie qui est uniquement pour les tests
    // Optionnel : Mets à jour une valeur dans ton UI pour afficher la distance
    document.getElementById('distanceToNextPoint').innerText = `Next point: ${Math.round(distance)} m`;
    return distance;
  }

  // créer une fonction pour recentrer la map sur la position de l'utilisateur
  recenter() {
    console.log('Recenter map');
    if (this.userLat && this.userLng) {
      this.map.setView([this.userLat, this.userLng], 13); // Recentrage sur la position de l'utilisateur
    }
  }

  // fonction de validation du marker
  validateMarker() {
    if (this.nextPoint.name === 'Hôtel Le Louis') {
      // Si le prochain point est l'hôtel Le Louis, on affiche un message de succès
      this.checkModalTitleTarget.innerText = 'Bravo !';
      this.checkModalBodyTarget.innerHTML = `
      <div> Féliciations vous avez trouvé l'ensemble des énigmes. Rdv à l'hotel Le Louis pour partager un cocktail</div>`;
      return;
    }


    const distance = this.calculateDistanceToNextPoint(this.userLat,this.userLng);
    if (distance < 50000) {
      console.log('Marker validated');
      // Envoi d'une requête pour valider le point
      fetch(`markers/${this.nextPoint.team_marker_id}/validate`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({
          visited: true
        })
      })
      .then(response => response.json())
      .then(data => {
        // Affiche un message de succès ou d'échec
        if (data.success) {
          this.clearMarkersAndCircles(); // On efface les marqueurs et cercles

          // Afficher les marqueurs déjà visités par l'équipe
          this.fetchVisitedTeamMarkers();
          // Récupérer le prochain point à visiter
          this.fetchNextTeamMarker().then(nextPoint => {
            if (nextPoint) {
              // Stocker la position du prochain point
              this.nextPoint = nextPoint;
            }
          });
          this.checkModalTitleTarget.innerText = 'Bravo !';
          this.checkModalBodyTarget.innerHTML = `
          <div> Féliciations vous avez validé l'énigme. Voici la prochaine :</div>
          <div >${this.nextPoint.enigma}</div>`;
          } else {
            alert('Oups il y a eu un problème, essayez de valider le point dans quelques minutes'); // TODO à retirer pour la prod
          }
        })
      } else {
        this.checkModalTitleTarget.innerText = 'Encore un effort !';
        this.checkModalBodyTarget.innerHTML = `
        <div> Vous y êtes presque, voici l'énigme du point à trouver:</div>
        <div >${this.nextPoint.enigma}</div>`;
      }
  }


  clearMarkersAndCircles() {
    // Efface les marqueurs et cercles de la carte
    console.log('Clearing markers and circles');
    // Supprimer tous les marqueurs
    this.markers.forEach(marker => {
      this.map.removeLayer(marker);
    });

    // Supprimer le cercle
    this.map.removeLayer(this.circle);

    // Vider les tableaux
    this.markers = [];
    this.circles = null;

  }

  raz() {
    // Réinitialise tous les TeamMarker de l'équipe
    console.log('RAZ');
    fetch('map/raz', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    }).then(response => response.json())
      .then(data => {
        if (data.success) {
          console.log('RAZ réussie');
        } else {
          console.error('RAZ échouée');
          // alert('RAZ échouée.'); // TODO à retirer pour la prod
        }
      })

  }

}
