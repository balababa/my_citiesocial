import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "template", "link", "item"]

  add_sku(event) {
    event.preventDefault();
    let content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime());
    this.linkTarget.insertAdjacentHTML('beforebegin', content)
  
  }
  
  remove_sku(event) {
    event.preventDefault();
    
    // let item = event.target.parentNode.parentNode.parentNode;
    let item = event.target.closest('.nested-fields');

    // item.getAttribute("data-new-record")
    if (item.dataset.newRecord == 'true')
      item.remove();
    else {
      item.querySelector("input[name*='_destroy']").value = 1
      item.style.display="none";
    }
  
  }
}
