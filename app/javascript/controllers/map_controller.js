import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

export default class extends Controller {
  connect() {
    this.initializeMap()
        if (typeof L === 'undefined') {
      console.error('Leaflet is not loaded');
      return;
    }

    console.log("Map controller connected");
  }

  initializeMap() {
    const map = L.map(this.element).setView([51.505, -0.09], 13)
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map)
  }
}





// import { Controller } from "@hotwired/stimulus";

// export default class extends Controller {
//   connect() {

//     if (typeof L === 'undefined') {
//       console.error('Leaflet is not loaded');
//       return;
//     }

//     console.log("Map controller connected");

//     const map = L.map(this.element).setView([48.8049, 2.1204], 14);
//     L.marker([48.807072, 2.125209]).addTo(map);
//     L.circle([48.807072, 2.125209], { radius: 200 }).addTo(map);
//   }
// }

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
