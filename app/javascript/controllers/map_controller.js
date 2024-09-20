import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "map" ]
  connect() {
    console.log("Map connected toto ")

    const L = window.L;
    this.map = L.map(this.mapTarget).setView([48.8049, 2.1204], 14);
    L.circle([48.8049, 2.1204],
      { radius: 200 ,
        color: 'red',
        fillColor: '#f03',
        fillOpacity: 0.5
      }).addTo(this.map);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(this.map);

    L.marker([48.8049, 2.1204]).addTo(this.map)
    .bindPopup('Un point d\'exemple.')
    .openPopup();
    console.log(L)
  }
}
