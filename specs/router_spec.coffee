frisby = require 'frisby'
lib    = require '../app/lib/'

notFound =
    message: "Not Found",
    documentation_url: lib.url ''

frisby
    .create 'bad request(1)'
    .get lib.url 'some_strange_directory'
    .expectStatus 404#400
    #.expectJSON notFound
    .toss()

frisby
    .create 'bad request(2)'
    .get lib.url 'some_strange_directory/not_acceptable'
    .expectStatus 404#400
    #.expectJSON notFound
    .toss()

frisby
    .create 'GET document.'
    .get lib.url ''
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'json'
    .toss()

frisby
    .create 'GET birds'
    .get lib.url 'birds'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'json'
    .toss()

frisby
    .create 'GET birds/スズメ'
    .get lib.url 'birds/スズメ'
    .expectStatus 200
    .toss()
