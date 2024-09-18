import { Controller } from "@hotwired/stimulus"
// import L from "leaflet"; // L est l'alias utilisé par Leaflet

export default class extends Controller {
  static targets = [ "map" ]
  connect() {
    console.log("Map connected")

    const L = window.L;
    this.map = L.map(this.mapTarget).setView([48.8049, 2.1204], 14);


    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(this.map);

    L.marker([48.8049, 2.1204]).addTo(this.map)
    .bindPopup('Un point d\'exemple.')
    .openPopup();
    L.circle([48.8049, 2.1204], { radius: 2000 }).addTo(this.map);
  }
}
