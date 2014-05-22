'use strict';

app.controller('GroupsCtrl', ['$scope', '$routeParams', '$location', 'groupsService', function ($scope, $routeParams, $location, groupsService) {

  $scope.groups = {};

  function init() {
    $scope.groups = groupsService.getGroups('2014 FIFA WORLD CUP');
  }

  init();

}]);
