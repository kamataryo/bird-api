frisby   = require 'frisby'
APIurl   = require('../utilities').getAPIurl
ObjectId = require('mongoose').Schema.Types.ObjectId

frisby
    .create 'bad request(1)'
    .get APIurl 'some_strange_directory'
    .expectStatus 404
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .toss()

frisby
    .create 'bad request(2)'
    .get APIurl 'some_strange_directory/not_acceptable'
    .expectStatus 404
    # .expectHeaderContains 'Content-Type', 'application/json'
    # .expectHeaderContains 'Content-Type', 'charset=UTF-8'
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
    .create 'GET birds'
    .get APIurl 'birds'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '', species: Array
    .expectJSONTypes 'species.*',
            sc: String
            ja: String
            alien: Boolean
            upper_id: String
    .expectJSON 'species.*', rank: 'species'
    .toss()


frisby
    .create 'GET birds with fields query'
    .get APIurl 'birds?fields=ja,rank'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '', species: Array
    .expectJSONTypes 'species.*',
            rank: String
            sc: undefined
            ja: String
            alien: undefined
            upper_id: undefined
    .toss()


frisby
    .create 'GET birds with limit query'
    .get APIurl 'birds?limit=20'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '', species: Array
    .expectJSONLength 'species', 20
    .toss()

frisby
    .create 'GET species with offset query'
    .get APIurl 'species?offset=100000000'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '', species: Array
    .expectJSONLength 'species',0
    .toss()


frisby
    .create 'GET genuses'
    .get APIurl 'genuses'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '', genuses: Array
    .expectJSONTypes 'genuses.*',
            sc: String
            ja: String
            upper_id: String
    .expectJSON 'genuses.*', rank: 'genus'
    .toss()


frisby
    .create 'GET families'
    .get APIurl 'families'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '', families: Array
    .expectJSONTypes 'families.*',
            sc: String
            ja: String
            upper_id: String
    .expectJSON 'families.*', rank: 'family'
    .toss()


frisby
    .create 'GET orders'
    .get APIurl 'orders'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '', orders: Array
    .expectJSONTypes 'orders.*',
            sc: String
            ja: String
    .expectJSON 'orders.*', rank: 'order'
    .toss()


frisby
    .create 'GET birds/スズメ'
    .get APIurl 'birds/スズメ'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '',
            species: Object
            biomen: String
            taxonomies: Array
    .expectJSONTypes 'species',
            sc: String
            ja: String
            alien: Boolean
            rank: String
            upper_id: String
    .expectJSONTypes 'taxonomies.*',
            sc: String
            ja: String
            rank: String
    .toss()


frisby
    .create 'GET birds/ヒドリガモ?fields=ja,alien'
    .get APIurl 'birds/ヒドリガモ?fields=ja,alien'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '',
            species: Object
            biomen: String
            taxonomies: Array
    .expectJSONTypes 'species',
            sc: undefined
            ja: String
            alien: Boolean
            rank: undefined
            upper_id: undefined
    .expectJSONTypes 'taxonomies.*',
            sc: undefined
            ja: String
            rank: undefined
    .toss()

frisby
    .create 'GET birds/ヒドリガモ?fields=ja,unknownField'
    .get APIurl 'birds/ヒドリガモ?fields=ja,unknownField'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '',
            species: Object
            biomen: String
            taxonomies: Array
    .expectJSONTypes 'species',
            sc: undefined
            ja: String
            alien: undefined
            rank: undefined
            upper_id: undefined
    .expectJSONTypes 'taxonomies.?',
            sc: undefined
            ja: String
            rank: undefined
    .toss()

frisby
    .create 'GET birds/ヒドリガモ?fields=onlyUnknownField'
    .get APIurl 'birds/ヒドリガモ?fields=onlyUnknownField'
    .expectStatus 200
    .expectHeaderContains 'Content-Type', 'application/json'
    .expectHeaderContains 'Content-Type', 'charset=UTF-8'
    .expectJSONTypes '',
            species: Object
            biomen: String
            taxonomies: Array
    .expectJSONTypes 'species',
            sc: String
            ja: String
            alien: Boolean
            rank: String
            upper_id: String
    .expectJSONTypes 'taxonomies.*',
            sc: String
            ja: String
            rank: String
    .toss()


frisby
    .create 'GET birds/undefined-bird-species'
    .get APIurl 'birds/undefined-bird-species'
    .expectStatus 404
    .toss()
