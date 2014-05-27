'use strict';

app.service('groupsService', ['$resource', function($resource){
  var groups = $resource('/tournaments/:tournament');

  this.getGroups = function(tournament){
    return groups.get({tournament: tournament});
  };

}]);
