frisby = require 'frisby'
lib    = require '../lib/'
APIurl    = lib.getAPIurl
ObjectId = require('mongoose').Schema.Types.ObjectId

notFoundResponse =
    message: "Not Found",
    documentation_url: APIurl ''

frisby
    .create 'bad request(1)'
    .get APIurl 'some_strange_directory'
    .expectStatus 404#400
    #.expectJSON notFoundResponse
    .toss()

frisby
    .create 'bad request(2)'
    .get APIurl 'some_strange_directory/not_acceptable'
    .expectStatus 404#400
    #.expectJSON notFoundResponse
    .toss()

frisby
    .create 'GET document, test of structure'
    .get APIurl ''
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
    .get APIurl 'birds'
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
    .get APIurl 'birds/スズメ'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes 'species',
            sc: String
            ja: String
            alien: Boolean
            rank: String
            upper_id: String
    .expectJSONTypes '', taxonomies: Array
    .expectJSON 'taxonomies.?', rank: 'genus'
    .expectJSON 'taxonomies.?', rank: 'family'
    .expectJSON 'taxonomies.?', rank: 'order'
    .toss()
