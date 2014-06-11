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

      Picks.update({id: pick.id, teamId: $routeParams.teamId}, pick, function success(){
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
    var swapped = false;
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
          Picks.update({id: dragEl.dataset.pickId, teamId: $routeParams.teamId, position: liIndex(dropEl)}, function success(){
            swapPicks(dragEl, dropEl);
            swapped = true;
          }, function error(response){
            console.log(response);
          });
        }
        if (dropEl.dataset.pickId) {
          Picks.update({id: dropEl.dataset.pickId, teamId: $routeParams.teamId, position: liIndex(dragEl)}, function success(){
            if (!swapped) {
              swapPicks(dragEl, dropEl);
            };
          }, function error(response){
            console.log(response);
          });
        }
      }
    });
  };

  init();

}]);
