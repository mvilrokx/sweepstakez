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

app.factory('Tournaments', ['$resource', function($resource){
  var Tournaments = $resource('/tournaments/:name', {name: '@name'}, {
  // var Tournaments = $resource('/tournaments/:id', {id: '@id',  name: '@name'}, {
    update: {
      method: 'PUT'
    }
  });

  return Tournaments;
}]);

'use strict';

app.factory('Teams', ['$resource', function($resource){
  var Teams = $resource('/teams/:id', {id: '@id'}, {
    update: {
      method: 'PUT'
    }
  });

  return Teams;
}]);

'use strict';

app.factory('Picks', ['$resource', function($resource){
  var Picks = $resource('/teams/:teamId/picks/:id', {teamId: '@teamId', id: '@id'}, {
    update: {
      method: 'PUT'
    }
  });

  return Picks;
}]);

'use strict';

app.service('rankingService', ['$http', function($http){
  var ranking = null;

  this.getRanking = function(tournamentName) {
    return $http.get('/tournaments/' + tournamentName + '/ranking').then(function success(response) {
      ranking = response.data;
      return ranking;
    }, function error(response) {
      if(response.status === 404){
        return ranking;
      } else {
        // TODO: Different error, raise something
      }
    });
  };

}]);

'use strict';

app.controller('MainCtrl', ['$scope', 'rankingService', function ($scope, rankingService) {
// app.controller('MainCtrl', ['$scope', 'session', function ($scope, session) {
  // $scope.ranking = rankingService.getRanking('2014 FIFA WORLD CUP');
  // console.log($scope.ranking);

  rankingService.getRanking('2014 FIFA WORLD CUP').then(function(ranking){
    $scope.ranking = ranking;
    console.log($scope.ranking);
  });


  // $scope.session = session;

  // $scope.loggedIn = function(){
  //   return !!session;
  // };

}]);



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

  init();

}]);

'use strict';

app.controller('TournamentsCtrl', ['$scope', 'Tournaments', function ($scope, Tournaments) {
  // TODO: Remove Hard coded tournament!
  function init() {
    $scope.tournament = Tournaments.get({name: '2014 FIFA WORLD CUP'});
    // $scope.tournament = Tournaments.get({id: 'dc043dc3-44b0-4abd-8fbd-411de8fd92ed'});
  }

  init();

}]);

'use strict';

app.controller('TeamsCtrl', ['$scope', 'Teams', function ($scope, Teams) {

  $scope.team = new Teams();

  function init() {
    $scope.teams = Teams.query();
  }

  $scope.editTeam = function(team) {
    team.editing = true;
  };

  $scope.resetTeam = function(team) {
    var dbFresh = Teams.get({id: team.id});
    dbFresh.editing = false;
    $scope.teams[_.findIndex($scope.teams, team)] = dbFresh;
  };

  $scope.saveTeam = function(team) {
    // Update DB
    if (team.id) {
      Teams.update({id: team.id}, team);
    } else {
      team.$save().then(function(response){
        $scope.teams.push(response);
      });
    }
    team.editing = false;
    $scope.team = new Teams();
    $scope.showForm = false;
  };

  $scope.deleteTeam = function(team) {
    // Delete from DB
    Teams.delete({id: team.id});

    // Update scope(and thus the view)
    // TODO This should really only be done if the save on DB succeeded
    _.remove($scope.teams, team);
  };

  init();

}]);

'use strict';

app.controller('PicksCtrl', ['$scope', '$routeParams', 'Picks', 'Teams', function ($scope, $routeParams, Picks, Teams) {
  var maxSelections = 8;

  $scope.team = Teams.get({id: $routeParams.teamId});
  $scope.pick = new Picks({teamId: $routeParams.teamId});

  function init() {
    $scope.picks = Picks.query({teamId: $routeParams.teamId}, function(){
      $scope.picks = sparsePicks($scope.picks, maxSelections);
    });
  }

  function sparsePicks(picks, maxSelections) {
    /*jshint camelcase: false */

    var sparseArrayPicks = [];

    $scope.picks.forEach(function(pick){
      sparseArrayPicks[pick.position-1] = pick;
    });

    for (var i = 0; i < maxSelections; ++i) {
      if(typeof sparseArrayPicks[i] === 'undefined') {
        sparseArrayPicks[i] = new Picks({teamId: $routeParams.teamId});
        sparseArrayPicks[i].position = i + 1;
        sparseArrayPicks[i].tournament_participant_id = null;
      }
    }
    return sparseArrayPicks;
  }

  function liIndex(li) {
    var i = 1;
    while ( li.previousElementSibling ) {
      li = li.previousElementSibling;
      i += 1;
    }
    return i;
  }

  function swapPicks(dragEl, dropEl) {
    var temp = $scope.picks[liIndex(dragEl) - 1];
    $scope.picks[liIndex(dragEl) - 1] = $scope.picks[liIndex(dropEl) - 1];
    $scope.picks[liIndex(dragEl) - 1].position = liIndex(dropEl);
    $scope.picks[liIndex(dropEl) - 1] = temp;
    $scope.picks[liIndex(dropEl) - 1].postion = liIndex(dragEl);
  }

  function addPick (pick, update) {
    /*jshint camelcase: false */

    update = update || false;

    if (pick.position > maxSelections) {
      // Update DB
      Picks.delete({id: pick.id, teamId: $routeParams.teamId});
      return;
    }

    var existingPick = $scope.picks[pick.position - 1];

    if (existingPick.tournament_participant_id !== null) {
      existingPick.position = existingPick.position + 1;
      addPick(existingPick, true);
    }

    if (update) {

      Picks.update({id: pick.id, teamId: $routeParams.teamId}, pick, function(){
        $scope.picks[pick.position - 1] = pick;
      });
    } else {
      pick.$save(
        function success(){
          $scope.picks[pick.position - 1] = pick;
          pick.teamId = $routeParams.teamId;
        },
        function error(response){
          console.log(response);
        }
      );
    }
  }


  $scope.editPick = function() {
    $scope.editing = true;
  };

  $scope.savePick = function(pick) {
    // Update DB
    if (pick.id) {
      Picks.update({id: pick.id}, pick);
    } else {
      pick.$save().then(function(response){
        $scope.picks.push(response);
      });
    }
    $scope.editing = false;
    // Update scope(and thus the view)
    $scope.pick = new Picks({teamId: $routeParams.teamId});
  };

  $scope.deletePick = function(pick) {
    // Delete from DB
    Picks.delete(pick);

    // Update scope(and thus the view)
    // TODO This should really only be done if the save on DB succeeded
    _.remove($scope.picks, pick);
  };

  $scope.dropped = function(dragEl, dropEl) {
    /*jshint camelcase: false */

    // I need $apply in order for the view to update because drag/drop events are not natively detected up by Angular.
    $scope.$apply(function () {
      if (dragEl.classList.contains('group-list-item')) { // dragged from groups

        // Check to make sure the country hasn't already been picked
        if (_.findIndex($scope.picks, { 'tournament_participant_id': dragEl.id }) === -1) {
          var newPick = new Picks({tournament_participant_id: dragEl.id, teamId: $routeParams.teamId, position: liIndex(dropEl)});
          addPick(newPick);
        }
      } else { // Swap picks
        if (dragEl.dataset.pickId) {
          Picks.update({id: dragEl.dataset.pickId, teamId: $routeParams.teamId, position: liIndex(dropEl)});
        }
        if (dropEl.dataset.pickId) {
          Picks.update({id: dropEl.dataset.pickId, teamId: $routeParams.teamId, position: liIndex(dragEl)});
        }
        swapPicks(dragEl, dropEl);
      }
    });
  };

  init();

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
        id = e.currentTarget.id;
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
