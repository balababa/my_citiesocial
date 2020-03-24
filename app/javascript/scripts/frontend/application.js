import bulmaCarousel from 'bulma-carousel/dist/js/bulma-carousel.min.js';

document.addEventListener("turbolinks:load", function(event) {
  let element = document.querySelector('#carousel');
  if (element) {
    bulmaCarousel.attach('#carousel', {
      slidesToScroll: 1,
      slidesToShow: 3,
      autoplay: true,
      infinite: true
    });
  }

})
