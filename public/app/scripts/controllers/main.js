'use strict';

app.controller('MainCtrl', ['$scope', 'session', 'sessionService', function ($scope, session, sessionService) {
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
