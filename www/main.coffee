app = angular.module 'myApp', []

app.controller 'SimpleAPIaccess', [
    '$scope'
    '$http'
    ($scope, $http) ->
        $scope.APIbase = 'http://bird-api.biwako.io/v1/'
        $scope.request = ->
            $http {
                method: 'GET'
                url: $scope.APIbase + $scope.APIend
            }
                .then (res)->
                    $scope.result = res.data
]



app.controller 'SearchTaxonomy', [
    '$scope'
    '$http'
    ($scope, $http) ->
        $scope.APIbase = 'http://bird-api.biwako.io/v1/birds/'
        $scope.request = ->
            $scope.taxFound = false
            $http {
                method: 'GET'
                url: $scope.APIbase + $scope.name
            }
                .then (res) ->
                    $scope.taxFound = true
                    $scope.taxonomies = res.data.taxonomies
                , ->
                    $scope.taxFound = false
]



app.controller 'birdNameHistogram', [
    '$scope'
    '$http'
    ($scope, $http) ->
        $scope.APIbase = 'http://bird-api.biwako.io/v1/inclusion?href='
        $scope.request = ->
            $http {
                method: 'GET'
                url: $scope.APIbase + $scope.url
            }
                .then (res) ->
                    console.log res
                    $scope.histogram = res.data.histogram
                , ->
                    $scope.histogram = undefined
]
