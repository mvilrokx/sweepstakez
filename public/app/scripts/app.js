'use strict';

var app = angular.module('sweepstakesApp', ['ngCookies', 'ngResource', 'ngSanitize', 'ngRoute', 'ngAnimate']);

app.config(function ($routeProvider) {
  $routeProvider
    .when('/', {
      templateUrl: 'views/main.html',
      controller: 'MainCtrl'
    })
    .when('/myselections', {
      templateUrl: 'views/mySelections.html',
      controller: 'mySelectionsCtrl'
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
