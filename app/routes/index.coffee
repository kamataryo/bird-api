# app/routes

Name    = require '../models/'
lib     = require '../lib/'
APIbase = lib.getAPIbase()

findUpperRankFromSpecies = (sp) ->
    Name.find {_id:sp.upper_id }, (err, genus)->

module.exports =
    document: (req, res) ->
        res.header 'Content-Type', 'application/json; charset=utf-8'
        res.json document:
            title:'とりAPIドキュメント'
            body:
                APIs: [{
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
                }]

    ranks: (req, res) ->
        res.header 'Content-Type', 'application/json; charset=utf-8'
        ranks = req.params.ranks
        rank = lib.singular_for[ranks]
        Name.find { rank }, (err, results) ->
            if err
                res.send err
            else
                if results.length < 1
                    res
                        .status 404
                        .json message: 'Unknown Resource'
                else
                    if ranks is 'birds' then ranks = 'species'
                    res.json { "#{ranks}":results }


    identifySpecies: (req, res) ->
        res.header 'Content-Type', 'application/json; charset=utf-8'
        Name.find {rank:"species", ja:req.params.identifier}, (err, result) ->
            # resultが複数帰ってきた場合は？
            if (err)
                res.send err
            else
                if result.length < 1
                    res
                        .status 404
                        .json  message: "Unknown bird name"
                    return

                species = result[0]._doc
                upper_id = species.upper_id
                allFields = Object.keys species
                if req.query.fields?
                    fields = req.query.fields.split ','
                    unless lib.atLeastContains fields, allFields
                        fields = allFields
                else
                    fields = allFields

                for field in allFields
                    unless field in fields then delete species[field]

                lib.attachUpperTaxonomies {
                    species
                    taxonomies: []
                    upper_id
                    fields
                    callback: (body) -> res.json body
                }
                # lib.attachUpperTaxonomies result[0], result[0].upper_id, (body) -> res.json body
