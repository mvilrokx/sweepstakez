'use strict';

describe('Service: mySelectionService', function () {

  // load the controller's module
  beforeEach(module('sweepstakesApp'));

  var mySelectionService;

  // Initialize the service
  beforeEach(inject(function(_mySelectionService_) {
    mySelectionService = _mySelectionService_;
  }));

  describe('Check if all methods are present', function() {
    it('should have an getMySelections function', function () {
      expect(angular.isFunction(mySelectionService.getMySelections)).toBe(true);
    });

    it('should have an addSelection function', function () {
      expect(angular.isFunction(mySelectionService.addSelection)).toBe(true);
    });

    it('should have an deleteSelection function', function () {
      expect(angular.isFunction(mySelectionService.deleteSelection)).toBe(true);
    });
  });


  describe('Check if it can manipulate the users selections properly', function() {
    var result;
    var expected;

    beforeEach(function() {
      mySelectionService.resetMySelections();
    });

    it('should return an array with 8 undefined values', function (){
      result = mySelectionService.getMySelections();
      expected = [{name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}];
      expect(result).toEqual(expected);
    });

    it('should add France in open position 2', function (){
      mySelectionService.addSelection(2, 'France');
      result = mySelectionService.getMySelections();
      expected = [{name: ''}, {name: 'France'}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}];
      expect(result).toEqual(expected);
    });

    it('should do nothing when trying to add position > maxSelections', function (){
      mySelectionService.addSelection(200, 'France');
      result = mySelectionService.getMySelections();
      expected = [{name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}];
      expect(result).toEqual(expected);
    });

    it('should add USA in open position 2 AND France in open postion 3', function (){
      mySelectionService.addSelection(3, 'France');
      mySelectionService.addSelection(2, 'USA');
      result = mySelectionService.getMySelections();
      expected = [{name: ''}, {name: 'USA'}, {name: 'France'}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}];
      expect(result).toEqual(expected);
    });

    it('should add USA in used position 2 AND move France that already occupied that postion to the next postion (3) which is still free', function (){
      mySelectionService.addSelection(2, 'France');
      mySelectionService.addSelection(2, 'USA');
      result = mySelectionService.getMySelections();
      expected = [{name: ''}, {name: 'USA'}, {name: 'France'}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}];
      expect(result).toEqual(expected);
    });

    it('should add Belgium in used position 2 AND move everything else down the list', function (){
      mySelectionService.addSelection(2, 'France');
      mySelectionService.addSelection(2, 'USA');
      mySelectionService.addSelection(2, 'Belgium');
      result = mySelectionService.getMySelections();
      expected = [{name: ''}, {name: 'Belgium'}, {name: 'USA'}, {name: 'France'}, {name: ''}, {name: ''}, {name: ''}, {name: ''}];
      expect(result).toEqual(expected);
    });

    it('should add Belgium in used position 8 AND move everything else off the list', function (){
      mySelectionService.addSelection(8, 'France');
      mySelectionService.addSelection(8, 'USA');
      mySelectionService.addSelection(8, 'Belgium');
      result = mySelectionService.getMySelections();
      expected = [{name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: 'Belgium'}];
      expect(result).toEqual(expected);
    });

    it('should delete Belgium in position 1', function (){
      mySelectionService.addSelection(1, 'Belgium');
      mySelectionService.deleteSelection(1);
      result = mySelectionService.getMySelections();
      expected = [{name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}, {name: ''}];
      expect(result).toEqual(expected);
    });

  });

});
