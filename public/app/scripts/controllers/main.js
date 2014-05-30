'use strict';

app.controller('MainCtrl', ['$scope', 'session', function ($scope, session) {
  $scope.awesomeThings = [
    'HTML5 Boilerplate',
    'AngularJS',
    'Karma'
  ];



  $scope.session = session;

  $scope.loggedIn = function(){
    return !!session;
  };

}]);
