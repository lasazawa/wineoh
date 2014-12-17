$(document).ready(function(){
  $('button.wine_color').click(function() {
    $(this).addClass('wine_color_selected');
    var wineColor = $(this).html;
    console.log(wineColor);
  });
});



// var snooth_url = "http://api.snooth.com/wines/?akey=8xo0yzmftoede3eczasvyrkedfs9hothrmaw1w69hohrtl12&q=" + wine.company + wine.vintage + wine.varietal;


//     // getSnoothRating(wines);



//     request(allEvents, function(error, response, body) {
//         // making sure theres no error and getting a successful 200 back
//         if (!error && response.statusCode == 200) {
//             var obj = JSON.parse(body);

//             var allEvents = obj.resultsPage.results.event;
//             // console.log(allEvents);