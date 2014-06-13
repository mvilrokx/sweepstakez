'use strict';

app.factory('Fixtures', ['$resource', function($resource){
  var Fixtures = $resource('/fixtures/:id', {id: '@id'}, {
    update: {
      method: 'PUT'
    }
  });

  return Fixtures;
}]);
