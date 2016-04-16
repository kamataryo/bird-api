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

        #parse `fields` query
        if req.query.fields?
            fields = req.query.fields
                .split ','
                .join ' '
        else
            fields = ''

        # parse `offset` query
        if req.query.offset?
            offset = parseInt req.query.offset
            if offset isnt offset
                offset = 0
            else
                if offset < 0 then offset = 0
        else
            offset = 0

        # parse `limit` query
        if req.query.limit?
            limit = parseInt req.query.limit
            if limit isnt limit
                limit = false
        else
            limit = false

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

            .catch (error) ->
                console.log error
                res
                    .status 500
                    .json message:'Internal Server Error'




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


    findInclusion: (req, res) ->
        res
            .header 'Content-Type', 'application/json; charset=utf-8'
            .header 'Access-Control-Allow-Origin', '*'

        Name.find {rank:'species'}, (err, allSpecies) =>
            histogram = []
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
                    replaced = content.replace (new RegExp ja, 'g'), ''
                    if content isnt replaced # species name found
                        frequency = (content.length - replaced.length) / ja.length
                        histogram.push { species, frequency }
                        content = replaced
                res
                    .status 200
                    .json { histogram }
