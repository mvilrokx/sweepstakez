'use strict';

app.factory('Tournaments', ['$resource', function($resource){
  var Tournaments = $resource('/tournaments/:id', {id: '@id'}, {
    update: {
      method: 'PUT'
    }
  });

  return Tournaments;
}]);
