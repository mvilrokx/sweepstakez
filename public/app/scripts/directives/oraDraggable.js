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
