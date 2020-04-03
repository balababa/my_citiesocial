import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "number"]

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
}
