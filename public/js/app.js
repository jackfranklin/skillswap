window.App = Ember.Application.create({
  rootElement: "#application"
});

App.Router.map(function() {
  this.resource("swaps", { path: "/" });
});

App.SwapsRoute = Ember.Route.extend({
  model: function() {
    return this.store.find("swap");
  }
});

App.ApplicationAdapter = DS.RESTAdapter.extend({
  namespace: 'api'
});

App.ApplicationController = Ember.Controller.extend({
  currentUser: $("#application").data("user"),
  userLoggedIn: function() {
    return !!this.get('currentUser');
  }.property('currentUser'),
  actions: {
    newswap: function() {
      var needed = this.get('skill_needed');
      var offered = this.get('skill_offered');
      var user = this.get('currentUser');
      if(!needed || !offered || !user) return;
      var swap = this.store.createRecord('swap', {
        skill_needed: needed,
        skill_offered: offered,
        user: user,
        created_at: new Date()
      });
      this.set('skill_needed', '');
      this.set('skill_offered', '');
      swap.save();
    }
  }
});

App.SwapsController = Ember.ArrayController.extend({
  filterText: '',
  searchNeededOnly: false,
  searchOfferedOnly: false,
  filtered: function() {
    var text = this.get('filterText');
    if(!text || text.length < 2) {
      return this.get('content').toArray().reverse();
    }

    text = text.toLowerCase();
    var searchNeededOnly = this.get('searchNeededOnly');
    var searchOfferedOnly = this.get('searchOfferedOnly');
    var filteredContent = this.get('content').filter(function(item) {
      var o = item.get('skill_offered').toLowerCase();
      var n = item.get('skill_needed').toLowerCase();
      if((searchNeededOnly && searchOfferedOnly) || (!searchNeededOnly && !searchOfferedOnly)) {
        return o.indexOf(text) > -1 || n.indexOf(text) > -1;
      } else if(searchNeededOnly) {
        return n.indexOf(text) > -1;
      } else if(searchOfferedOnly) {
        return o.indexOf(text) > -1;
      }
    });

    return filteredContent.reverse();

  }.property("@each", 'filterText', 'searchNeededOnly', 'searchOfferedOnly')
});

App.Swap = DS.Model.extend({
  skill_needed: DS.attr('string'),
  skill_offered: DS.attr('string'),
  user: DS.attr('string'),
  created_at: DS.attr('date')
});

Ember.Handlebars.helper('twitter-intent', function(user, skill, classes, linkText) {
  var str = '<a class="' + classes + '" href="https://twitter.com/intent/tweet?text=@' + user + ', I can help you with ' + skill + '! (via SkillSwap)">' + linkText + '</a>';
  return new Handlebars.SafeString(str);
});

Ember.Handlebars.helper('twitter-profile', function(user) {
  console.log(user);
  return new Handlebars.SafeString("<a href='https://twitter.com/" + user + "'>" + user + "</a>");
});
