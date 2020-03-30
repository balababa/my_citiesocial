import Sortable from 'sortablejs';

document.addEventListener('turbolinks:load', (event) => {
  let list = document.querySelector('.list-group');

  if (list) {
    Sortable.create(list, { 
      animation: 150,
      onEnd: function (evt) {

        let [model, id] = evt.item.dataset.item.split('_');
        
        console.log(model,id)
        console.log(evt.oldIndex, evt.newIndex)

      },
    });
  }
})