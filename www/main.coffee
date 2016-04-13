app = angular.module 'myApp', []

app.controller 'mainCtrl', [
    '$scope'
    '$http'
    ($scope, $http) ->
        $scope.APIbase = 'http://bird-api.biwako.io/v1/'
        $scope.request = ->
            url = $scope.APIbase + $scope.APIend
            $http.get url, (result)->
                $scope.result = result
]
