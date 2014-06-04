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
