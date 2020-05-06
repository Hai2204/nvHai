//add map
function initMap() {
    //u location
    const loc = { lat: 17.235101, lng: 106.759949 };
    //centered map on location
    const map = new google.maps.Map(document.querySelector('.map'),{
        zoom: 14,
        center: loc
    });
    //the market,positioned at location
    const marker = new google.maps.Marker({ position: loc, map:map });
  }
  //ngay gio
function gettime(){
    var d = new Date();
    var dh;
    dh = d.getHours();
    
        document.getElementById('#navbar').innerHTML = Date();
    
    
};
  //sticky menu background
window.addEventListener('scroll', function(){
    if(window.scrollY > 150){
        document.querySelector('#navbar').style.opacity = 0.9;}
    else {
        document.querySelector('#navbar').style.opacity = 0.9;
        }
    
});


  // Smooth Scrolling
$('#navbar a, .btn').on('click', function(event){
      if (this.hash !== ''){
          event.preventDefault();

          const hash = this.hash;

          $('html, body').animate({
              scrollTop: $(hash).offset().top - 100
          },
          800);
      }
  });
