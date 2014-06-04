'use strict';

app.factory('Tournaments', ['$resource', function($resource){
  var Tournaments = $resource('/tournaments/:name', {name: '@name'}, {
  // var Tournaments = $resource('/tournaments/:id', {id: '@id',  name: '@name'}, {
    update: {
      method: 'PUT'
    }
  });

  return Tournaments;
}]);
