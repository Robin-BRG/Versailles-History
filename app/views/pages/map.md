<%= render 'shared/navbar' %>

<div id="map-container">
  <div id="map" data-controller="map"></div>
  <%= render 'shared/menu_button' %>
  <%= render 'shared/check_modal' %>
  <%= render 'shared/enigma_modal' %>
  <%= render 'shared/gallery_modal' %>
  <%= render 'shared/information_modal' %>
</div>

<script>
    var map = L.map('map').setView([48.8049, 2.1204], 14);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        maxZoom: 50
    }).addTo(map);

    // Fonction pour générer des points aléatoires dans un rayon de 50 mètres
    function getRandomPoint(center, radius) {
        var y0 = center.lat;
        var x0 = center.lng;
        var rd = radius / 111300; // Rayon en degrés

        var u = Math.random();
        var v = Math.random();
        var w = rd * Math.sqrt(u);
        var t = 2 * Math.PI * v;
        var x = w * Math.cos(t);
        var y = w * Math.sin(t);

        // Ajustement des coordonnées
        var newLat = y + y0;
        var newLng = x + x0;
        return [newLat, newLng];
    }

    // Fonction pour vérifier si un point est dans un cercle
    function isPointInCircle(point, circleCenter, radius) {
        var latDiff = point.lat - circleCenter.lat;
        var lngDiff = point.lng - circleCenter.lng;
        var distance = Math.sqrt(latDiff * latDiff + lngDiff * lngDiff);
        return distance <= radius / 111300; // Convertir le rayon en degrés
    }

    // Ajout des cercles et des marqueurs pour chaque point GPS
    var circles = [];
    <% if @markers.present? %>
        <% @markers.each do |marker| %>
            var randomPoint = getRandomPoint({lat: <%= marker.latitude %>, lng: <%= marker.longitude %>}, 50);
            var circle = L.circle(randomPoint, {
                color: 'blue',
                fillColor: '#30f',
                fillOpacity: 0.5,
                radius: 100
            }).addTo(map);
            var pin = L.marker([<%= marker.latitude %>, <%= marker.longitude %>]).addTo(map);
            circles.push({circle: circle, enigma: "<%= j marker.enigma %>"});
        <% end %>
    <% end %>

    // Geolocation
    function onLocationFound(e) {
        var userRadius = 100; // Définir le rayon du cercle bleu autour de l'utilisateur

        L.marker(e.latlng).addTo(map)

        L.circle(e.latlng, userRadius).addTo(map);

        // Vérifier si l'utilisateur est dans un des cercles
        circles.forEach(function(item) {
            if (isPointInCircle(e.latlng, item.circle.getLatLng(), item.circle.getRadius())) {
                // Afficher la modal avec l'énigme
                document.getElementById('enigmaModalBody').innerText = item.enigma;
                $('#enigmaModal').modal('show');
            }
        });
    }

    function onLocationError(e) {
        alert(e.message);
    }

    map.on('locationfound', onLocationFound);
    map.on('locationerror', onLocationError);

    // Activer la géolocalisation avec un zoom plus prononcé
    map.locate({setView: true, maxZoom: 20});

    document.addEventListener('DOMContentLoaded', (event) => {
        const recenterButton = document.getElementById('recenter-map');

        recenterButton.addEventListener('click', (e) => {
            e.preventDefault();
            map.locate({setView: true, maxZoom: 20});
        });
    });
</script>