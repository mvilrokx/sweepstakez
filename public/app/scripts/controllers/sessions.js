'use strict';

app.controller('SessionsCtrl', ['$scope', 'sessionService', function ($scope, sessionService) {
  // $scope.session = sessionService.getCurrentUser();

  sessionService.getCurrentUser().then(function(session){
    $scope.session = session;
  });

  $scope.loggedIn = function(){
    return sessionService.isAuthenticated();
  };

}]);
