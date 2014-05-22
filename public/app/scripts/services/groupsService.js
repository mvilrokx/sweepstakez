'use strict';

app.service('groupsService', ['$resource', function($resource){
  var groups = $resource('/groups/:tournament');

  this.getGroups = function(tournament){
    return groups.get({tournament: tournament});
  };

}]);
