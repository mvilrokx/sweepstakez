'use strict';

app.service('groupsService', [function(){
  var groups = {
    '2014 FIFA WORLD CUP': {
      A: ['Brazil', 'Croatia', 'Mexico', 'Cameroon'],
      B: ['Spain', 'Netherlands', 'Chile', 'Australia'],
      C: ['Colombia', 'Greece', 'Côte D\'Ivoire', 'Japan'],
      D: ['Uruguay', 'Costa Rica', 'England', 'Italy'],
      E: ['Switzerland', 'Ecuador', 'France', 'Honduras'],
      F: ['Argentina', 'Bosnia and Herzegovina', 'Iran', 'Nigeria'],
      G: ['Germany', 'Portugal', 'Ghana', 'USA'],
      H: ['Belgium', 'Algeria', 'Russia', 'Korea Republic']
    }
  };

  this.getGroups = function(tournament){
    return groups[tournament];
  };

}]);

