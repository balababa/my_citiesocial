import Sortable from 'sortablejs';
import Rails from "@rails/ujs";


document.addEventListener('turbolinks:load', (event) => {
  let list = document.querySelector('.list-group');

  if (list) {
    Sortable.create(list, { 
      animation: 150,
      onEnd: function (evt) {
        if (evt.oldIndex == evt.newIndex) {
          return
        }
        let [model, id] = evt.item.dataset.item.split('_');
        let data = new FormData();
        data.append("id", id);
        data.append("from", evt.oldIndex);
        data.append("to", evt.newIndex);

        Rails.ajax({
          url: "/admin/categories/sort",
          type: "PUT",
          dataType: 'json',
          data,
          success: response => {
            console.log(response)
          },
          error: err => {
            console.log(response)
          }
        })  

      },
    });
  }
})