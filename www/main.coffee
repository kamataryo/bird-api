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
                .then (result)->
                    $scope.result = result.data
]
