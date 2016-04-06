frisby = require 'frisby'
version = require('../package.json').version.split('.')[0]
url = (dir) ->
    "http://localhost:3000/#{version}/#{dir}"

frisby
    .create 'Test run of frisby.'
    .get url('')
    .expectStatus 200
    .toss()

frisby
    .create 'Test of GET birds'
    .get url('birds')
    .expectStatus 200
    .toss()
