import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

export default class extends Controller {
  static targets = [ "map" ]

  connect() {
    console.log("Map controller connected");
  }
}
