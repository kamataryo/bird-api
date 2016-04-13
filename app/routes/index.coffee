# app/routes

Name    = require '../models'
util    = require '../utilities'
APIbase = util.getAPIbase()
_       = require 'underscore'


module.exports =
    doc: (req, res) ->
        res.header 'Content-Type', 'application/json; charset=utf-8'
        res.json document:
            title:'日本の野鳥 Web API'
            links:[
                {
                    rel:"git-repository"
                    href:"https://github.com/KamataRyo/bird-api"
                }
            ]


    ranks: (req, res) ->
        res.header 'Content-Type', 'application/json; charset=utf-8'
        # get plural form of rank
        ranks = req.params.ranks
        rank = util.singular_for[ranks]
        Name.find { rank }, (err, results) ->
            if err
                res
                    .status 500
                    .json message:"Internal Server Error"
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
        res.header 'Content-Type', 'application/json; charset=utf-8'
        Name.find {rank:"species", ja:req.params.identifier}, (err, result) ->
            if (err)
                res
                    .status 500
                    .json message:"Internal Server Error"

            else
                if result.length < 1
                    res
                        .status 404
                        .json  message: "Unknown bird name"
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


                # recurse getting upper taxonomy
                util.attachUpperTaxonomies {
                    species
                    taxonomies: []
                    upper_id
                    fieldsAcceptable
                    callback: (body) -> res.json body
                }
