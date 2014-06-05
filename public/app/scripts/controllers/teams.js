'use strict';

app.controller('TeamsCtrl', ['$scope', 'Teams', function ($scope, Teams) {

  $scope.team = new Teams();

  function init() {
    $scope.teams = Teams.query();
  }

  $scope.editTeam = function(team) {
    team.editing = true;
  };

  $scope.resetTeam = function(team) {
    var dbFresh = Teams.get({id: team.id});
    dbFresh.editing = false;
    $scope.teams[_.findIndex($scope.teams, team)] = dbFresh;
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
    team.editing = false;
    $scope.team = new Teams();
  };

  $scope.deleteTeam = function(team) {
    // Delete from DB
    Teams.delete({id: team.id});

    // Update scope(and thus the view)
    // TODO This should really only be done if the save on DB succeeded
    _.remove($scope.teams, team);
  };

  init();

}]);
