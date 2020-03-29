import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "email" ]

  connect() {
  }
  
  add(event) {
    event.preventDefault();
    let email = this.emailTarget.value.trim();
    let data = new FormData();
    data.append("subscribe[email]", email)

    Rails.ajax({
      url: "/api/v1/subscribe",
      type: "post",
      dataType: 'json',
      data,
      success: function(data) { console.log(data)},
      error: function(data) {console.log(data)},
    })
  }
}
