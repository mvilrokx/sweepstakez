'use strict';

app.service('sessionService', ['$http', '$q', function($http, $q){
  var currentUser = null;

  this.getCurrentUser = function() {
    if (this.isAuthenticated()) {
      return $q.when(currentUser);
    } else {
      return $http.get('/v1/users/current').then(function success(response) {
        currentUser = response.data;
        return currentUser;
      }, function error(response) {
        if(response.status === 404){
          return currentUser;
        } else {
          // TODO: Different error, raise something
        }
      });
    }
  };


  this.isAuthenticated = function() {
    return !!currentUser;
  };

}]);
