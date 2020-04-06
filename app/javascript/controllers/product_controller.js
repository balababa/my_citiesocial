import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "number", "sku"]

  connect() {

  }

  cal(val) {
    let target = this.numberTarget
    let number = Number(target.value);
    target.value = (number + val < 1) ? 1 : number + val
  }

  add(event) {
    event.preventDefault();
    this.cal(1);
   
  }

  subtract(event) {
    event.preventDefault();
    this.cal(-1);
  }

  add_to_cart(event) {
    event.preventDefault();

    let sku = this.skuTarget.value;
    let product_id = this.data.get("id");
    let quantity = this.numberTarget.value;

    if (quantity > 0) {
      event.target.classList.add("is-loading");
      let data = new FormData();
      data.append("id", product_id);
      data.append("quantity", quantity);
      data.append("sku", sku);
      Rails.ajax({
        url: "/api/hello",
        data,
        type: "post",
        success: response => {

        },
        error: err => {

        }
      });

    }
  }
}
