$(document).ready(function() {
    
      $('.pictures').cycle({
         fx: 'fade', 
         speed:  300,  
         timeout: 0 ,
         prev: '#prev',
         next: '#next , .pictures',
         after: onAfter
         before: function() {  
            $('#titleCaption').html(this.src); 
        }
       });


      function onAfter(curr,next,opts) {
         var caption =  (opts.currSlide + 1) + ' of ' + opts.slideCount;
         $('#caption').html(caption);
      }
    
      function editCaption(string) {
           string = string.replace(/images\/.*\//g, '');
           return string;
       }


});