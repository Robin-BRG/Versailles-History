import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Map controller connected toto ");

    const map = L.map(this.element).setView([48.8049, 2.1204], 14);
    L.marker([48.807072, 2.125209]).addTo(map);
    L.circle([48.807072, 2.125209], { radius: 200 }).addTo(map);
  }
}

// export default class extends Controller {
//   static targets = ["map"]

//   connect() {
//     this.initializeMap()
//     console.log("Coucou")
//   }

//   initializeMap() {
//     const map = L.map(this.mapTarget).setView([48.8049, 2.1204], 14)

//     L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
//       attribution: '&copy; OpenStreetMap contributors'
//     }).addTo(map)

//     L.marker([48.807072, 2.125209]).addTo(map)

//     L.circle([48.807072, 2.125209], {
//       radius: 200,
//       color: 'red',
//       fillColor: '#f03',
//       fillOpacity: 0.5
//     }).addTo(map)
//   }
// }
