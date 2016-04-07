frisby  = require 'frisby'
meta    = require '../package.json'
version = meta.version.split('.')[0]

# run server
#server  = require "../#{meta.main}"

host = 'localhost'
port = '3000'

url = (dir) ->
    "http://#{host}#{if port then ':' + port}/#{version}/#{dir}"


frisby
    .create 'bad request(1)'
    .get url('some_strange_directory')
    .expectStatus 404
    .expectJSON {
        "message": "Not Found",
        "documentation_url": url ''
    }
    .toss()

frisby
    .create 'bad request(2)'
    .get url 'some_strange_directory/not_acceptable'
    .expectStatus 400
    .toss()

frisby
    .create 'GET document.'
    .get url ''
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'json'
    .toss()

frisby
    .create 'GET birds'
    .get url 'birds'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'json'
    .toss()

frisby
    .create 'GET birds/スズメ'
    .get url 'birds/スズメ'
    .expectStatus 200
    .toss()
