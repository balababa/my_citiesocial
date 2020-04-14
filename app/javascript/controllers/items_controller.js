import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "total"]

  connect() {
  }

  cal(event) {
    event.preventDefault();
    let target = event.currentTarget;
    let sym = target.dataset["val"];
    let offset = sym == '+' ? 1 : -1
    let sku_id = target.closest('tr').dataset["skuId"]
    let item_num = document.querySelector(`#cart_item${sku_id}`);
    let item_sum = document.querySelector(`#cart_item_total${sku_id}`);


    if ( !(Number(item_num.innerHTML) == 0 && offset == -1 )) {

    let data = new FormData();
    data.append("offset", offset)
    data.append("sku_id", sku_id)


    Rails.ajax({
      url: "/api/v1/change_item_num",
      type: "post",
      dataType: 'json',
      data,
      success: (response) => {
        item_num.innerHTML = response.num;
        item_sum.innerHTML = response.sum;

        this.totalTarget.innerHTML = response.total;
      },
      error: function(response) {console.log(response)},
    })
  }
  }
}
