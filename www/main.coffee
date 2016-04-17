app = angular.module 'myApp', ['chart.js']
app.controller 'birdNameHistogram', [
    '$scope'
    '$http'
    ($scope, $http) ->
        $scope.content = '''
            日本ではカモ類の多くは渡り鳥ですが、カルガモは留鳥で、年中観察することができます。
            マガモは渡りを行いますが、日本で繁殖する場合もあります。
            滋賀県米原市にある三島池はマガモの繁殖の南限地として有名です。
            琵琶湖では、ヒドリガモ、コガモ、オナガガモ、キンクロハジロ、ホシハジロ、スズガモなどのカモ類が多く見られます。
            これらのうち、ヒドリガモ、コガモ、オナガガモ、キンクロハジロ、ホシハジロは狩猟鳥です。
            コガモは狩猟者から「べ」と呼ばれます。
            その他に、カワアイサ、ウミアイサ、ミコアイサなどのアイサ類、コブハクチョウやコハクチョウ、ヒシクイ、オオヒシクイなどのガン類も見られます。
      '''
        $scope.APIbase = 'http://bird-api.biwako.io/v1/'

        $scope.request = ->
            if $scope.histogram?
                labels = []
                data = []
                for key,value of $scope.histogram[$scope.rank]
                    labels.push key
                    data.push value
                $scope.labels = labels
                $scope.data = data
                return
            else
                $scope.histogram = {}

            options =
                method: 'GET'
                url: $scope.APIbase + 'inclusion?content=' + $scope.content

            $http(options).then ({data}) ->
                histogram = data.histogram
                subRequests = []
                for sp in data.histogram
                    options =
                        method: 'GET'
                        url: $scope.APIbase + 'birds/' + sp.species.ja
                    subRequests.push $http(options)

                Promise.all(subRequests)
                    .then (results) ->
                        # transform object
                        buffers = []
                        for i in [0..histogram.length-1]
                            results[i].data.taxonomies.unshift {rank:'species', ja: results[i].data.name.ja}
                            for taxnomy in results[i].data.taxonomies
                                buffers.push {
                                    frequency: histogram[i].frequency
                                    ja: taxnomy.ja
                                    rank: taxnomy.rank
                                }

                        for buffer in buffers
                            rank = buffer.rank
                            ja = buffer.ja
                            frequency = buffer.frequency
                            unless $scope.histogram[rank]?
                                $scope.histogram[rank] = {}
                            unless $scope.histogram[rank][ja]?
                                $scope.histogram[rank][ja] = 0
                            $scope.histogram[rank][ja] += frequency

                        labels = []
                        data = []
                        for key,value of $scope.histogram[$scope.rank]
                            labels.push key
                            data.push value
                        $scope.labels = labels
                        $scope.data = data
]
