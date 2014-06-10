'use strict';

app.controller('MainCtrl', ['$scope', 'rankingService', function ($scope, rankingService) {
// app.controller('MainCtrl', ['$scope', 'session', function ($scope, session) {
  // $scope.ranking = rankingService.getRanking('2014 FIFA WORLD CUP');
  // console.log($scope.ranking);

  rankingService.getRanking('2014 FIFA WORLD CUP').then(function(ranking){
    $scope.ranking = ranking;
  });


  // $scope.session = session;

  // $scope.loggedIn = function(){
  //   return !!session;
  // };

}]);


