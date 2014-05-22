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
