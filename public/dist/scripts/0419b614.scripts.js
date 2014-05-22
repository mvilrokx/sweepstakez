"use strict";var app=angular.module("sweepstakesApp",["ngCookies","ngResource","ngSanitize","ngRoute","ngAnimate"]);app.config(["$routeProvider",function(a){a.when("/",{templateUrl:"views/main.html",controller:"MainCtrl"}).when("/myselections",{templateUrl:"views/mySelections.html",controller:"mySelectionsCtrl"}).otherwise({redirectTo:"/"})}]),app.factory("_",["$window",function(a){return a._}]),app.service("groupsService",["$resource",function(a){var b=a("/groups/:tournament");this.getGroups=function(a){return b.get({tournament:a})}}]),app.service("mySelectionService",[function(){var a=[],b=8;this.resetMySelections=function(){for(var c=0;b>c;)a.push({name:""}),c++},this.getMySelections=function(){return 0===a.length&&this.resetMySelections(),a},this.swapSelection=function(b,c,d,e){a[b-1]={name:e},a[d-1]={name:c}},this.addSelection=function(c,d){if(!(c>b)){var e=a[c-1];""!==e.name&&this.addSelection(c+1,e.name),a[c-1]={name:d}}},this.deleteSelection=function(b){a[b-1]={name:""}}}]),app.service("uuidService",[function(){for(var a=[],b=0;256>b;b++)a[b]=(16>b?"0":"")+b.toString(16);this.getUUID=function(){var b=4294967295*Math.random()|0,c=4294967295*Math.random()|0,d=4294967295*Math.random()|0,e=4294967295*Math.random()|0;return a[255&b]+a[b>>8&255]+a[b>>16&255]+a[b>>24&255]+"-"+a[255&c]+a[c>>8&255]+"-"+a[c>>16&15|64]+a[c>>24&255]+"-"+a[63&d|128]+a[d>>8&255]+"-"+a[d>>16&255]+a[d>>24&255]+a[255&e]+a[e>>8&255]+a[e>>16&255]+a[e>>24&255]}}]),app.controller("MainCtrl",["$scope",function(a){a.awesomeThings=["HTML5 Boilerplate","AngularJS","Karma"]}]),app.controller("GroupsCtrl",["$scope","$routeParams","$location","groupsService",function(a,b,c,d){function e(){a.groups=d.getGroups("2014 FIFA WORLD CUP")}a.groups={},e()}]),app.controller("mySelectionsCtrl",["$scope","$routeParams","$location","mySelectionService",function(a,b,c,d){function e(){a.mySelections=d.getMySelections()}function f(a){for(var b=1;a.previousElementSibling;)a=a.previousElementSibling,b+=1;return b}a.mySelections=[],a.dropped=function(b,c){a.$apply(function(){b.classList.contains("group-list-item")?d.addSelection(f(c),b.dataset.name):d.swapSelection(f(b),b.dataset.name,f(c),c.dataset.name)})},e()}]),app.directive("oraDraggable",["$rootScope","uuidService",function(a,b){return{restrict:"A",link:function(c,d){d.attr("draggable",!0);var e=d.attr("id");e||(e=b.getUUID(),d.attr("id",e)),d.bind("dragstart",function(b){b.dataTransfer.setData("text/plain",e),b.dataTransfer.setData("text",e),b.dataTransfer.effectAllowed="move",b.target.classList.add("ora-drag-start"),a.$emit("ora-drag-start")}),d.bind("drag",function(){a.$emit("ora-drag")}),d.bind("dragend",function(b){b.target.classList.remove("ora-drag-start"),a.$emit("ora-drag-end")})}}}]),app.directive("oraDropTarget",["$rootScope","uuidService",function(a,b){return{restrict:"A",scope:{onDrop:"&"},link:function(c,d){var e=d.attr("id");e||(e=b.getUUID(),d.attr("id",e)),d.bind("dragover",function(a){a.dataTransfer.dropEffect="move",a.preventDefault()}),d.bind("dragenter",function(a){a.target.classList.add("ora-drag-enter"),a.preventDefault()}),d.bind("dragleave",function(a){a.target.classList.remove("ora-drag-enter")}),d.bind("drop",function(a){var b=a.dataTransfer.getData("text"),d=document.getElementById(e),f=document.getElementById(b);d!==f&&c.onDrop({dragEl:f,dropEl:d}),a.preventDefault()}),a.$on("ora-drag-start",function(){document.getElementById(e).classList.add("ora-target")}),a.$on("ora-drag-end",function(){var a=document.getElementById(e);a.classList.remove("ora-target"),a.classList.remove("ora-drag-enter")})}}}]);