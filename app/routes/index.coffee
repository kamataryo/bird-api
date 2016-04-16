# app/routes
Name    = require '../models'
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
        Name.find { rank }, (err, results) ->
            if err
                res
                    .status 500
                    .json message:'Internal Server Error'
            else
                if results.length < 1
                    res
                        .status 404
                        .json message: 'Unknown Resource'
                else
                    if ranks is 'birds' then ranks = 'species'

                    # filter fields
                    allFields = Object.keys results[0]._doc
                    if req.query.fields?
                        fieldsAcceptable = req.query.fields.split ','
                        unless util.atLeastContains fieldsAcceptable, allFields
                            fieldsAcceptable = allFields
                    else
                        fieldsAcceptable = allFields


                    # deal limit query
                    if req.query.limit?
                        limit = parseInt req.query.limit
                        if limit isnt limit
                            limit = results.length
                        else
                            if limit < 0 then limit = 0
                    else
                        limit = results.length

                    # deal offset query
                    if req.query.offset?
                        offset = parseInt req.query.offset
                        if offset isnt offset
                            offset = 0
                        else
                            if offset < 0 then offset = 0
                    else
                        offset = 0

                    results = results.slice offset+1, limit+offset+1
                    for result in results
                        util.acceptFieldsInTaxonomy fieldsAcceptable, result._doc
                    res.json { "#{ranks}":results }


    identifySpecies: (req, res) ->
        res
            .header 'Content-Type', 'application/json; charset=utf-8'
            .header 'Access-Control-Allow-Origin', '*'
        Name.find {rank:"species", ja:req.params.identifier}, (err, result) ->
            if err
                res
                    .status 500
                    .json message:'Internal Server Error'

            else
                if result.length < 1
                    res
                        .status 404
                        .json  message:'Unknown bird name'
                    return

                # use as normal JSON
                species = result[0]._doc
                upper_id = species.upper_id

                # filter fields
                allFields = Object.keys species
                if req.query.fields?
                    fieldsAcceptable = req.query.fields.split ','
                    unless util.atLeastContains fieldsAcceptable, allFields
                        fieldsAcceptable = allFields
                else
                    fieldsAcceptable = allFields

                # get upper taxonomies recursively in this function
                util.attachUpperTaxonomies {
                    species
                    taxonomies: []
                    upper_id
                    fieldsAcceptable
                    callback: (body) -> res.json body
                }


    askExistence: (req, res) ->
        res
            .header 'Content-Type', 'application/json; charset=utf-8'
            .header 'Access-Control-Allow-Origin', '*'
        Name.find {ja:req.params.identifier}, (err, results) ->
            if err
                res
                    .status 500
                    .json message:'Internal Server Error'

            if results.length > 0
                result = results[0]
                res
                    .status 200
                    .json {
                        existence:true
                        species:result
                    }
            else
                res
                    .status 200
                    .json existence:false


    findIncluded: (req, res) ->
        res
            .header 'Content-Type', 'application/json; charset=utf-8'
            .header 'Access-Control-Allow-Origin', '*'

        Name.find {rank:'species'}, (err, allSpecies) =>
            histogram = {}
            content = req.query.content
            unless content? then content = ''

            if err
                res
                    .status 500
                    .json message:'Internal Server Error'

            else
                # sort allSpecies
                allSpecies.sort (a, b)->
                    b.ja.length - a.ja.length

                # find species name
                for species in allSpecies
                    ja = species.ja
                    replaced = body.replace ja, ''
                    if body isnt replaced
                        unless histogram[ja]
                            histogram[ja] = (body.length - replaced.length) / ja.length
                        else
                            histogram[ja] += (body.length - replaced.length) / ja.length
                        body = replaced
                res
                    .status 200
                    .json { histogram }
