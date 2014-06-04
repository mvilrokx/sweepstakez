'use strict';

app.factory('Picks', ['$resource', function($resource){
  var Picks = $resource('/teams/:teamId/picks/:id', {teamId: '@teamId', id: '@id'}, {
    update: {
      method: 'PUT'
    }
  });

  return Picks;
}]);
