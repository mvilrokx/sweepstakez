'use strict';

var app = angular.module('sweepstakesApp', ['ngCookies', 'ngResource', 'ngSanitize', 'ngRoute', 'ngAnimate']);

app.config(function ($routeProvider) {
  $routeProvider
    .when('/', {
      templateUrl: 'views/main.html',
      controller: 'MainCtrl',
      // resolve: {
      //   session: function(sessionService) {
      //     return sessionService.getCurrentUser();
      //   }
      // }
    })
    .when('/myselections', {
      templateUrl: 'views/mySelections.html',
      controller: 'mySelectionsCtrl'
    })
    .when('/myteams', {
      templateUrl: 'views/userTeams.html',
      controller: 'TeamsCtrl'
    })
    .when('/myteams/:teamId/mypicks', {
      templateUrl: 'views/userPicks.html',
      controller: 'PicksCtrl'
    })
    .otherwise({
      redirectTo: '/'
    });
});

// Add lodash to angular
app.factory('_', ['$window',
  function($window) {
    // place lodash include before angular
    return $window._;
  }
]);
