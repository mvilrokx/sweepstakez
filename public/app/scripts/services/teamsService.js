'use strict';

app.factory('Teams', ['$resource', function($resource){
  var Teams = $resource('/teams/:id', {id: '@id'}, {
    update: {
      method: 'PUT'
    }
  });

  return Teams;
}]);
