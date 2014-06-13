'use strict';

app.controller('FixturesCtrl', ['$scope', 'Fixtures', 'sessionService', function ($scope, Fixtures, sessionService) {

  $scope.fixtures = [];

  function init() {
    $scope.fixtures = Fixtures.query();
  }


  $scope.addFixture = function(fixture) {
    if (fixture.id) {
      // TODO: Needs callback I think
      Fixtures.update({id: fixture.id}, fixture);
    } else {
      fixture.$save();
    }
    fixture.editing = false;
  };


  $scope.deleteFixture = function(fixture) {
    fixture.$delete();
  };


  $scope.editFixture = function(fixture){
    fixture.editing = true;
  };

  sessionService.getCurrentUser().then(function(session){
    $scope.session = session;
  });

  init();

}]);
