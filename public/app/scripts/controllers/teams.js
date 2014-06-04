'use strict';

app.controller('TeamsCtrl', ['$scope', 'Teams', function ($scope, Teams) {

  $scope.team = new Teams();

  function init() {
    $scope.teams = Teams.query();
    console.log($scope.teams);
  }

  $scope.editTeam = function() {
    $scope.editing = true;
  };

  $scope.saveTeam = function(team) {
    // Update DB
    if (team.id) {
      Teams.update({id: team.id}, team);
    } else {
      team.$save().then(function(response){
        $scope.teams.push(response);
      });
    }
    $scope.editing = false;
    // Update scope(and thus the view)
    $scope.team = new Teams();
  };

  $scope.deleteTeam = function(team) {
    // Delete from DB
    Teams.delete(team);

    // Update scope(and thus the view)
    // TODO This should really only be done if the save on DB succeeded
    _.remove($scope.teams, team);
  };

  init();

}]);
