# app/routes

Name    = require '../models'
util    = require '../utilities'
APIbase = util.getAPIbase()
_       = require 'underscore'


module.exports =
    doc: (req, res) ->
        res.header 'Content-Type', 'application/json; charset=utf-8'
        res.json document:
            title:'日本の野鳥 Web APIドキュメント'
            body:
                APIs: [
                    {
                        API: "GET #{APIbase}"
                        description: 'このドキュメント'
                    },{
                        API: "GET #{APIbase}/birds"
                        description: '日本で見られるすべての鳥について、名前Objectをすべて取得'
                        returns: '{species: [Species]}'
                    },{
                        API: "GET #{APIbase}/birds/{:鳥の名前}"
                        description: '標準和名を指定して該当する種の名前Objectを取得'
                        returns: '{species: Species, taxonomies: [taxonomy]}'
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
                            if limit < 0
                                limit = 0
                    else
                        limit = results.length

                    results = results.slice 1, limit+1

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
