$(document).ready(function() {
  // totalQuotes is the number of all quotes fetched using ajax
  // pageCount = Math.ceil(totalQuotes / quotesPerPage)
  var totalQuotes;
  var quotesPerPage = 10;
  var pageCount = 4;

  // $.ajax({
  //   url: 'https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json',
  //   type: 'GET',
  //   dataType: 'json'
  // }).done( function(data) {
  //   var content = data;
  // });

  for (var i = 0; i < pageCount; i++) {
    $('#pagination').append('<li><a href="#">'+ (i + 1) + '</a></li>');
  }

  $("#pagination li").first().find("a").addClass("current")
  showPage = function(page) {
    $(".quote-content").hide();

    $(".quote-content").each(function(n) {
      var batch = $(this);
      if (n >= quotesPerPage * (page - 1) && n < quotesPerPage * page) {
        batch.show();
      }
    });
	}

	$("#pagination li a").click(function() {
    $("#pagination li a").removeClass("current");
    $(this).addClass("current");
    showPage(parseInt($(this).text()))
	});

});
