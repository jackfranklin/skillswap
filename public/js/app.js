$(function() {
  var skills = $(".swap");
  $("input[name='swap-filter']").on("keyup", function(e) {
    var value = this.value.toLowerCase();
    if(value.length < 1) {
      skills.show();
    }
    skills.each(function() {
      var self = $(this);
      if(self.text().toLowerCase().indexOf(value) > -1) {
        self.show();
      } else {
        self.hide();
      }
    });
  });
  $("#filter-form").on("submit", function(e) {
    e.preventDefault();
  });

  $('.alert-box').on('click', function(){
    $(this).hide();
  });

});
