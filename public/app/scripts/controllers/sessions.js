'use strict';

app.controller('SessionsCtrl', ['$scope', '$location', 'sessionService', function ($scope, $location, sessionService) {
  // $scope.session = sessionService.getCurrentUser();

  sessionService.getCurrentUser().then(function(session){
    $scope.session = session;
  });

  $scope.loggedIn = function(){
    return sessionService.isAuthenticated();
  };

  $scope.isActive = function (viewLocation) {
    return viewLocation === $location.path();
  };

}]);
