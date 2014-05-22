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

