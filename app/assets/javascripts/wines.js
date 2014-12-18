$(document).ready(function(){

var container = document.querySelector('#container');
var msnry = new Masonry( container, {
  // options...
  itemSelector: '.item',
  columnWidth: 200
});

$(function(){

  $('#masonry-container').masonry({
    itemSelector: '.box',
    columnWidth: 100,
    isAnimated: !Modernizr.csstransitions,
    isRTL: true
  });

});
//   $('button.wine_color').click(function() {
//     $(this).addClass('wine_color_selected');
//     var wineColor = $(this).html();
//     console.log(wineColor);
//     // ajax for color of wine
//     $.post('/filter', {wineColor: wineColor}).done(function(response) {
//       console.log(response);
//       console.log(response[0]);
//       // jquery new element
//       $('#wine_tile_container').append(response);
//     });
//   });


});

