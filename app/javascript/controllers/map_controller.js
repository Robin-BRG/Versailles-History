import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "map", "enigmaModal", "recenterButton", "checkModalBody", "checkModalTitle", "galleryModal" ]



  connect() {
    this.initializeMap();  // Initialisation de la carte
    this.fetchVisitedTeamMarkers();  // Chargement des marqueurs déjà visités
    this.getLocation();  // Récupération de la localisation de l'utilisateur

    // Attacher l'événement de soumission du mot de passe
    const form = document.getElementById('passwordForm');
    if (form) {
      form.addEventListener('submit', this.validatePassword.bind(this)); // Gère la validation du mot de passe
    }

    this.fetchNextTeamMarker().then(nextPoint => {
      if (nextPoint) {
        this.nextPoint = nextPoint;
      }
    });
  }

  // fonction initialiser la map avec un centrage sur Versailles
  initializeMap() {
    const L = window.L;
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
      });
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
      // console.log(data.next_team_marker);
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
        this.updateGalleryModal(data);
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
    const nextPointLat = this.nextPoint.marker_coordinates[0]; // Récupère les coordonnées du prochain point
    const nextPointLng = this.nextPoint.marker_coordinates[1];

    // Utilise la méthode distance de Leaflet pour calculer la distance en mètres
    const distance = L.latLng(userLat, userLng).distanceTo(L.latLng(nextPointLat, nextPointLng));

    if (distance <= 200) { // si l'utilisateur est à moins de 50m du prochain point on affiche le cercle

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
    return distance;
  }

  // créer une fonction pour recentrer la map sur la position de l'utilisateur
  recenter() {
    if (this.userLat && this.userLng) {
      this.map.setView([this.userLat, this.userLng], 15); // Recentrage sur la position de l'utilisateur
    }
  }

  validatePassword(event) {
    event.preventDefault();

    const passwordInput = document.getElementById("passwordInput").value; // Récupérer le mot de passe entré

    fetch(`markers/${this.nextPoint.team_marker_id}/validate`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({
        password: passwordInput // Envoi du mot de passe au back-end
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.clearMarkersAndCircles(); // Nettoyer la carte si succès

        // Afficher un message de félicitations
        this.checkModalBodyTarget.innerHTML = `
          <div> Félicitations, vous avez validé ce point !</div>`;

        // Fermer la modale après 2 secondes
        setTimeout(() => {
          const modal = bootstrap.Modal.getInstance(document.getElementById('CheckModal'));
          if (modal) modal.hide();

          // Réinitialiser le champ du mot de passe pour permettre une nouvelle validation
          document.getElementById("passwordInput").value = '';
          document.getElementById("errorMessage").style.display = 'none'; // Cacher le message d'erreur
        }, 2000);
      } else {
        // Afficher le message d'erreur si le mot de passe est incorrect
        document.getElementById("errorMessage").style.display = 'block';
      }
    })
    .catch(error => {
      console.error('Erreur de validation du marqueur :', error);
    });
  }

  // fonction de validation du marker
  validateMarker() {
    // Si le prochain point est l'hôtel Le Louis, on affiche un message de succès et on arrête la fonction

    if (this.nextPoint.is_last_marker) {

      this.checkModalTitleTarget.innerText = 'Bravo !';
      this.checkModalBodyTarget.innerHTML = `
        <div> Félicitations, vous avez trouvé l'ensemble des énigmes. Rendez-vous à l'hôtel Le Louis pour partager un cocktail.<br>
        vous pouvez valider le dernier point en entrant le mot de passe : ${this.nextPoint.marker_pass}</div>`;
      return;  // On quitte la fonction ici
    }

    const distance = this.calculateDistanceToNextPoint(this.userLat, this.userLng);


    // Si la distance est trop grande, on affiche un message et on arrête la fonction
    if (distance >= 50) {
      this.checkModalTitleTarget.innerText = 'Encore un effort !';
      this.checkModalBodyTarget.innerHTML = `
        <div> Vous y êtes presque, voici l'énigme du point à trouver :</div>
        <div>${this.nextPoint.enigma}</div>`;
      return;  // On quitte la fonction ici si la distance est trop grande
    }

    // Si la distance est correcte, on fait l'appel pour valider le point
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
      if (data.success) {
        this.clearMarkersAndCircles(); // On efface les marqueurs et cercles

        // Récupérer le prochain point à visiter
        this.fetchNextTeamMarker().then(nextPoint => {
          if (nextPoint) {
            this.nextPoint = nextPoint;
            this.checkModalTitleTarget.innerText = 'Bravo !';
            // console.log(this.nextPoint);
            if (this.nextPoint.is_last_marker) {
              this.checkModalBodyTarget.innerHTML = `
              <div>${this.nextPoint.enigma}</div>`;

            }else {
            this.checkModalBodyTarget.innerHTML = `
              <div> Félicitations, vous avez validé l'énigme. Voici la prochaine :
              <br></br>
              </div>

              <div>${this.nextPoint.enigma}</div>`;
            }
          }
        });

        // Afficher les marqueurs déjà visités par l'équipe
        this.fetchVisitedTeamMarkers();

      } else {
        alert('Oups, il y a eu un problème. Essayez de valider le point dans quelques minutes.');
      }
    });
  }

  clearMarkersAndCircles() { // Efface les marqueurs et cercles de la carte

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
          console.log('RAZ échouée');
        }
      })

  }


  updateGalleryModal(data) {
    // Trier les marqueurs visités par ordre d'ID
    const sortedMarkers = data.visited_team_markers
      .filter(marker => marker.visited);

    // Placer chaque marqueur dans la div correspondante
    sortedMarkers.forEach((visitedTeamMarker) => {
      const markerDiv = document.getElementById(`marker-${visitedTeamMarker.id}`);
      if (markerDiv) {
        markerDiv.querySelector('h3').innerText = visitedTeamMarker.name;
        markerDiv.querySelector(`#content-${visitedTeamMarker.id} p`).innerText = visitedTeamMarker.content;
      }
    });
  }

  
  
  

  
}






