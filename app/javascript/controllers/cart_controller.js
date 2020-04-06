import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "count" ]

  connect() {
  }

  updateCart(event) {
    let data = event.detail;
    console.log(data)
    this.countTarget.innerHTML = `(${data.item_count})`; 
  }
}
