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
  sortAscending: false,
  sortProperties: ['created_at']
});

App.Swap = DS.Model.extend({
  skill_needed: DS.attr('string'),
  skill_offered: DS.attr('string'),
  user: DS.attr('string'),
  created_at: DS.attr('date')
});
