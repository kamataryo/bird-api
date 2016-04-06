frisby  = require 'frisby'
meta    = require '../package.json'
version = meta.version.split('.')[0]

# run server
#server  = require "../#{meta.main}"

url = (dir) ->
    "http://localhost:3000/#{version}/#{dir}"

frisby
    .create 'Test run of frisby.'
    .get url('')
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'json'
    .toss()

frisby
    .create 'Test of GET birds'
    .get url('birds')
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'json'
    .toss()

frisby
    .create 'Test of GET birds/スズメ'
    .get url('birds/スズメ')
    .expectStatus 200
    .toss()
