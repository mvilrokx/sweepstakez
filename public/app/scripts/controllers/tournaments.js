'use strict';

app.controller('TournamentsCtrl', ['$scope', 'Tournaments', function ($scope, Tournaments) {
  // TODO: Remove Hard coded tournament!
  function init() {
    $scope.tournament = Tournaments.get({id: 'dc043dc3-44b0-4abd-8fbd-411de8fd92ed'});
  }

  init();

}]);
