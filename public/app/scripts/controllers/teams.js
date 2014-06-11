'use strict';

app.controller('TeamsCtrl', ['$scope', '$location','Teams', function ($scope, $location, Teams) {

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
      // team.$save().then(function(response){
      //   console.log(response);
      //   $scope.teams.push(response);
      // });
      team.$save(function success(response) {
        $scope.teams.push(response);
        $location.path('/myteams/' + response.id + '/mypicks');
      }, function error(response){
        //  TODO Show message to user that Tournament has started
        console.log(response);
      });
    }
    team.editing = false;
    $scope.team = new Teams();
    $scope.showForm = false;
  };

  $scope.deleteTeam = function(team) {
    // Delete from DB
    Teams.delete({id: team.id}, function success (){
      // Update scope(and thus the view)
      _.remove($scope.teams, team);
    }, function error(response){
      console.log(response);
    });
  };

  init();

}]);
