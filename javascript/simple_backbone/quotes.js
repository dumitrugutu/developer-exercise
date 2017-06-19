$(document).ready(function() {

  // Quote Model
  var Quote = Backbone.Model.extend({
  	defaults: {
  		source: '',
      context: '',
      quote: '',
      theme: ''
  	}
  });

  // A List of Quotes
  var QuotesCollection = Backbone.Collection.extend({
  	model: Quote
  });

  // View for all people
  var QuotesView = Backbone.View.extend({
  	tagName: 'ul',

  	render: function() {
  		this.collection.each(function(quote) {
  			var quoteView = new QuoteView({ model: quote });
  			this.$el.append(quoteView.render().el);
  		}, this);

  		return this;
  	}
  });

  // The View for a Quote
  var QuoteView = Backbone.View.extend({
  	tagName: 'p',
    className: 'quote-content',

  	template: _.template( $('#quoteTemplate').html()),

  	render: function() {
  		this.$el.html( this.template(this.model.toJSON()) );
  		return this;
  	}
  });

  // Fetch the data and feed to the Quotes Collection
  $.ajax({
    url: 'https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json',
    type: 'GET',
    dataType: 'json'
  }).done( function(data) {
    var content = data;
    var quotesCollection = new QuotesCollection(content)
    var quotesView = new QuotesView({ collection: quotesCollection });
    $(document.body).append(quotesView.render().el);
  });

  $('button').on('click', function() {
    var theme = $(this).val();
    filterQuotes(theme)
  })

  // Filters the quotes on games and movies
  var filterQuotes = function(theme) {
    $.ajax({
      url: 'https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json',
      type: 'GET',
      dataType: 'json'
    }).done( function(data) {
      var quotesCollection = new QuotesCollection(data)
      var filteredCollection = quotesCollection.where({theme: theme})
      var newCollection = new QuotesCollection(filteredCollection)
      var quotesView = new QuotesView({ collection: newCollection });
      $(".quote-content").hide();
      $(document.body).append(quotesView.render().el);
    });
  }
});
