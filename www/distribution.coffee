app = angular.module 'myApp', ['ngMap']

app.config [
    '$httpProvider'
    ($httpProvider) ->
        $httpProvider.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=utf-8'
]

app.controller 'bird-distribution', [
    'NgMap'
    '$http'
    '$scope'
    (NgMap, $http, $scope) ->
        $scope.post = ->
            $http {
                method: 'POST'
                url: 'http://bird-api.biwako.io/v1/distributions'
                data: "ja=#{$scope.ja}&place=#{$scope.place}"
            }
                .success (data, status) ->
                    $scope.lastPostStatus = status
                .error (data, status) ->
                    $scope.lastPostStatus = status

        $scope.get = ->
            $http {
                method: 'GET'
                url: "http://bird-api.biwako.io/v1/distributions/#{$scope.ja}"
            }
                .success (data, status) ->
                    $scope.lastGetStatus = status
                    $scope.distributions = data.distributions
                .error (data, status) ->
                    $scope.lastGetStatus = status
]
