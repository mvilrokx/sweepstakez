'use strict';

app.service('rankingService', ['$http', function($http){
  var ranking = null;

  this.getRanking = function(tournamentName) {
    return $http.get('/tournaments/' + tournamentName + '/ranking').then(function success(response) {
      ranking = response.data;
      return ranking;
    }, function error(response) {
      if(response.status === 404){
        return ranking;
      } else {
        // TODO: Different error, raise something
      }
    });
  };

}]);
