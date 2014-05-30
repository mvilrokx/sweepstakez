'use strict';

var app = angular.module('sweepstakesApp', ['ngCookies', 'ngResource', 'ngSanitize', 'ngRoute', 'ngAnimate']);

app.config(function ($routeProvider) {
  $routeProvider
    .when('/', {
      templateUrl: 'views/main.html',
      controller: 'MainCtrl',
      resolve: {
        session: function(sessionService) {
          return sessionService.getCurrentUser();
        }
      }
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

'use strict';

app.service('groupsService', ['$resource', function($resource){
  var groups = $resource('/tournaments/:tournament');

  this.getGroups = function(tournament){
    return groups.get({tournament: tournament});
  };

}]);

'use strict';

app.service('mySelectionService', [function(){
  var mySelection = [];
  var maxSelections = 8;

  this.resetMySelections = function(){
    var count = 0;
    while (count < maxSelections) {
      mySelection.push({name: ''});
      count++;
    }
  };

  this.getMySelections = function(){
    if (mySelection.length === 0) { this.resetMySelections(); }
    return mySelection;
  };

  this.swapSelection = function(dragPos, dragName, dropPos, dropName) {
    mySelection[dragPos - 1] = {name: dropName};
    mySelection[dropPos - 1] = {name: dragName};
  };

  this.addSelection = function(position, name) {
    if (position > maxSelections) {return;}

    var existingSelection = mySelection[position - 1];

    if (existingSelection.name !== '') {
      this.addSelection(position + 1, existingSelection.name);
    }
    mySelection[position - 1] = {name: name};
  };

  // this.updateMySelections = function(id, name, desc) {
  //   for (var i = 0; i < mySelection.length; i++) {
  //     if (mySelection[i].id === id) {
  //       mySelection[i].name = name;
  //       mySelection[i].description = desc;
  //       break;
  //     }
  //   }
  // };

  this.deleteSelection = function(position){
    mySelection[position - 1] = {name: ''};
  };

}]);


/*jslint bitwise: true */

'use strict';

// This service generates a UUID that we need for drag and drop functionality
// I take 0 credit for this super fast method that I found here:
//   http://stackoverflow.com/questions/105034/how-to-create-a-guid-uuid-in-javascript/21963136#21963136
app.service('uuidService', [function(){

  var lut = [];
  for (var i=0; i<256; i++) { lut[i] = (i<16?'0':'')+(i).toString(16); }

  this.getUUID = function(){
    var d0 = Math.random()*0xffffffff|0;
    var d1 = Math.random()*0xffffffff|0;
    var d2 = Math.random()*0xffffffff|0;
    var d3 = Math.random()*0xffffffff|0;
    return lut[d0&0xff]+lut[d0>>8&0xff]+lut[d0>>16&0xff]+lut[d0>>24&0xff]+'-'+ lut[d1&0xff]+lut[d1>>8&0xff]+'-'+lut[d1>>16&0x0f|0x40]+lut[d1>>24&0xff]+'-'+ lut[d2&0x3f|0x80]+lut[d2>>8&0xff]+'-'+lut[d2>>16&0xff]+lut[d2>>24&0xff]+ lut[d3&0xff]+lut[d3>>8&0xff]+lut[d3>>16&0xff]+lut[d3>>24&0xff];
  };

}]);

'use strict';

app.service('sessionService', ['$http', '$q', function($http, $q){
  var currentUser = null;

  this.getCurrentUser = function() {
    if (this.isAuthenticated()) {
      return $q.when(currentUser);
    } else {
      return $http.get('/v1/users/current').then(function success(response) {
        currentUser = response.data;
        return currentUser;
      }, function error(response) {
        if(response.status === 404){
          return currentUser;
        } else {
          // TODO: Different error, raise something
        }
      });
    }
  };


  this.isAuthenticated = function() {
    return !!currentUser;
  };

}]);

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

'use strict';

app.controller('GroupsCtrl', ['$scope', '$routeParams', '$location', 'groupsService', function ($scope, $routeParams, $location, groupsService) {

  $scope.groups = {};

  function init() {
    $scope.groups = groupsService.getGroups('2014 FIFA WORLD CUP');
  }

  init();

}]);

'use strict';

app.controller('mySelectionsCtrl', ['$scope', '$routeParams', '$location', 'mySelectionService', function ($scope, $routeParams, $location, mySelectionService) {

  $scope.mySelections = [];

  $scope.dropped = function(dragEl, dropEl) {
    // I need $apply in order for the view to update because drag/drop events are not natively detected up by Angular.
    $scope.$apply(function () {
      if (dragEl.classList.contains('group-list-item')) {
        mySelectionService.addSelection(liIndex(dropEl), dragEl.dataset.name);
      } else {
        mySelectionService.swapSelection(liIndex(dragEl), dragEl.dataset.name, liIndex(dropEl), dropEl.dataset.name);
      }
    });
  };

  function init() {
    $scope.mySelections = mySelectionService.getMySelections();
  }

  function liIndex(li) {
    var i = 1;
    while ( li.previousElementSibling ) {
      li = li.previousElementSibling;
      i += 1;
    }
    return i;
  }

  // function randomData() {
  //   mySelectionService.addSelection(1, 'Belgium');
  //   mySelectionService.addSelection(3, 'Brazil');
  //   mySelectionService.addSelection(4, 'France');
  //   mySelectionService.addSelection(6, 'Italia');
  //   mySelectionService.addSelection(8, 'Argentina');
  // }

  init();
  // randomData();

}]);

'use strict';

app.directive('oraDraggable', ['$rootScope', 'uuidService', function($rootScope, uuidService) {
  return {
    restrict: 'A',
    // replace: false,
    link: function (scope, element) {

      // Make element "draggable"
      element.attr('draggable', true); // ideally this should be conditional (don't allow to drag empty items), but then this needs to be kept up-to-date as values change.  I have found no disadvantage in doing it this way, dragging and dropping empty items works just the same and as well as non-empty items.

      // Set a UUID on the element so we can keep track of it while dragging
      var id = element.attr('id');

      if (!id) {
        id = uuidService.getUUID();
        element.attr('id', id);
      }

      // bind drag events to element
      element.bind('dragstart', function(e){
        e.dataTransfer.setData('text/plain', id);
        e.dataTransfer.setData('text', id); // fallback for IE
        e.dataTransfer.effectAllowed = 'move';
        e.target.classList.add('ora-drag-start');
        $rootScope.$emit('ora-drag-start');
      });

      element.bind('drag', function(){
        // e.dataTransfer.setData('text', id);
        $rootScope.$emit('ora-drag');
      });

      element.bind('dragend', function(e){
        e.target.classList.remove('ora-drag-start');
        $rootScope.$emit('ora-drag-end');
      });

    }
  };
}]);

'use strict';

app.directive('oraDropTarget', ['$rootScope', 'uuidService', function($rootScope, uuidService) {
  return {
    restrict: 'A',
    scope: {
      onDrop: '&'
    },
    link: function(scope, element) {

      var id = element.attr('id');

      if (!id) {
        id = uuidService.getUUID();
        element.attr('id', id);
      }

      element.bind('dragover', function(e) {
        e.dataTransfer.dropEffect = 'move';
        e.preventDefault(); // Necessary. Allows us to drop (see https://developer.mozilla.org/en-US/docs/DragDrop/Drag_Operations)
      });

      element.bind('dragenter', function(e) {
        // TODO: Only apply class if you enter a different element than the one you are dragging
        // This is not possible as you do not have access to the src element in this event, this is done for security reasons
        e.target.classList.add('ora-drag-enter');
        e.preventDefault(); // Necessary. Allows us to drop. (see https://developer.mozilla.org/en-US/docs/DragDrop/Drag_Operations)
      });

      element.bind('dragleave', function(e) {
        e.target.classList.remove('ora-drag-enter');
      });

      element.bind('drop', function(e) {
        var data = e.dataTransfer.getData('text');
        var dest = document.getElementById(id);
        var src = document.getElementById(data);
        if (dest !== src) {
          scope.onDrop({dragEl: src, dropEl: dest});
        }

        e.preventDefault(); // Necessary. Allows us to drop. (see https://developer.mozilla.org/en-US/docs/DragDrop/Drag_Operations)
      });

      // These are events that are fired by the oraDraggable directive
      $rootScope.$on('ora-drag-start', function() {
        document.getElementById(id).classList.add('ora-target');
      });

      $rootScope.$on('ora-drag-end', function() {
        var el = document.getElementById(id);
        el.classList.remove('ora-target');
        el.classList.remove('ora-drag-enter');
      });
    }
  };
}]);
