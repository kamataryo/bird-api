frisby = require 'frisby'
lib    = require '../lib/'
ObjectId = require('mongoose').Schema.Types.ObjectId

notFoundResponse =
    message: "Not Found",
    documentation_url: lib.url ''

frisby
    .create 'bad request(1)'
    .get lib.url 'some_strange_directory'
    .expectStatus 404#400
    #.expectJSON notFoundResponse
    .toss()

frisby
    .create 'bad request(2)'
    .get lib.url 'some_strange_directory/not_acceptable'
    .expectStatus 404#400
    #.expectJSON notFoundResponse
    .toss()

frisby
    .create 'GET document, test of structure'
    .get lib.url ''
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes 'document', title: String
    .expectJSONTypes 'document.body', APIs: Array
    .expectJSONTypes 'document.body.APIs.?',
        API: String
        description: String
    .toss()

frisby
    .create 'GET all the list of birds'
    .get lib.url 'birds'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '', species: Array
    .expectJSONTypes 'species.?',
            sc: String
            ja: String
            alien: Boolean
            upper_id: String
    .expectJSON 'species.?', rank: 'species'
    .toss()

frisby
    .create 'GET birds/スズメ'
    .get lib.url 'birds/スズメ'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '', species: Array
    .expectJSONTypes 'species.?',
            sc: String
            ja: String
            alien: Boolean
            rank: String
            upper_id: String
        # genus: String
        #family: String
        #order: String
    .toss()
