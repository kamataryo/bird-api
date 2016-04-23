# app/routes
Name         = require('../models').Name
Distribution = require('../models').Distribution
util    = require '../utilities'
_       = require 'underscore'

module.exports =
    doc: (req, res) ->
        res
            .header 'Content-Type', 'application/json; charset=utf-8'
            .header 'Access-Control-Allow-Origin', '*'
            .json document:
                title:'日本の野鳥 Web API'
                links:[
                    {
                        rel:"git-repository"
                        href:"https://github.com/KamataRyo/bird-api"
                    }
                ]


    ranks: (req, res) ->
        res
            .header 'Content-Type', 'application/json; charset=utf-8'
            .header 'Access-Control-Allow-Origin', '*'
        # get plural form of rank
        ranks = req.params.ranks
        rank = util.singular_for[ranks]

        { fields, offset, limit } = util.parseQuery req

        promise = Name
            .find {rank}
            .select fields
            .skip offset # map skip as offset for request
            .limit limit
            .exec()

        promise
            .then (results) ->
                if results.length < 1
                    res
                        .status 404
                        .json message: 'Unknown Resource'
                else
                    # set Alias
                    if ranks is 'birds' then ranks = 'species'

                    res.json { "#{ranks}":results }

            .catch (err) ->
                res
                    .status 400
                    .json message:'bad request.'



    identifyName: (req, res) ->
        # parse params
        ranks = req.params.ranks
        rank = util.singular_for[ranks]
        identifier = req.params.identifier

        # parse queries
        { fields } = util.parseQuery req

        res
            .header 'Content-Type', 'application/json; charset=utf-8'
            .header 'Access-Control-Allow-Origin', '*'

        promise1 = Name
            .find {rank, ja:identifier}
            .select fields
            .exec()

        promise2 = Name
            .find {rank, ja:identifier}
            .exec()

        Promise.all [promise1, promise2]
            .then ([results, references]) ->
                if results.length < 1
                    res
                        .status 404
                        .json  message:'Unknown bird name'
                else
                    name = results[0]
                    reference = references[0]

                    if reference.upper_id?
                        # get upper taxonomies recursively in this function
                        util.attachUpperTaxonomies {
                            name      # filtered object
                            reference # non-filtered onject
                            fields    # filter
                            callback: (body) -> res.json body
                        }
                    else
                        res.json { name }

            .catch (err) ->
                console.log err
                res
                    .status 500
                    .json message:'Internal Server Error'



    askExistence: (req, res) ->
        # parse params
        identifier = req.params.identifier

        # parse queries
        { fields } = util.parseQuery req

        res
            .header 'Content-Type', 'application/json; charset=utf-8'
            .header 'Access-Control-Allow-Origin', '*'

        Name
            .find {rank:'species', ja:identifier}
            .select fields
            .exec()
            .then (results) ->
                if results.length > 0
                    result = results[0]
                    res
                        .status 200
                        .json {
                            existence: true
                            name: result
                        }
                else
                    res
                        .status 200
                        .json existence: false
            .catch (err) ->
                console.log err
                res
                    .status 500
                    .json message:'Internal Server Error'



    findInclusion: (req, res) ->
        # parse queries
        { content } = util.parseQuery req

        res
            .header 'Content-Type', 'application/json; charset=utf-8'
            .header 'Access-Control-Allow-Origin', '*'

        Name
            .find {rank:'species'}
            .exec()
            .then (allSpecies) ->
                histogram = []
                # sort allSpecies
                allSpecies.sort (a, b)->
                    b.ja.length - a.ja.length

                # find species name
                for species in allSpecies
                    ja = species.ja
                    replaced = content.replace (new RegExp ja, 'g'), ''
                    if content isnt replaced # species name found
                        frequency = (content.length - replaced.length) / ja.length
                        histogram.push { species, frequency }
                        content = replaced
                res
                    .status 200
                    .json { histogram }

            .catch (err) ->
                console.log err
                res
                    .status 500
                    .json message:'Internal Server Error'



    getDistributions: (req, res) ->
        return



    getDistributionsOf: (req, res) ->
        # parse params
        identifier = req.params.identifier
        res
            .header 'Content-Type', 'application/json; charset=utf-8'
            .header 'Access-Control-Allow-Origin', '*'

        promise1 = Name
            .find {rank:'species', ja:identifier}
            .select '_id'
            .exec()
            .then (results) ->
                if results.length < 1
                    res.
                        .status 404
                        .json  message:'Unknown bird name'
                    throw new Error 'Unknown bird name'
                else
                    return results[0]
            .then ({id})->
                Distribution
                    .find {name_id: id}
                    .exec()
                    .then (results) ->
                        res
                            .status 200
                            .json {name:identifier, distributions:results}

            .catch (err) ->
                console.log err



    postDistributionsOf: (req, res) ->
        # parse body
        {ja, place} = req.body.ja, req.body.place
        unless ja? or place?
            res
                .status 404
                .json {message: 'no `ja` or `place` field in body.'}
        else
            Name
                .find {rank:species, ja}
                .select '_id'
                .exec()
                .then (results)->
                    if results.length < 1
                        res
                            .status 404
                            .json {message: 'no birdname registered.'}
                        throw new Error 'Unknown bird name'
                    else
                        return results[0]._id
                .then (bird_id) ->
                    Distribution
                        .insert {bird_id, place}
                        .exec()
                .then (insertion) ->
                    if insertion
                        res
                            .status 200
                            .json {message: 'post success.'}
