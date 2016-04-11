# app/routes

Name    = require '../models/'
lib     = require '../lib/'
APIbase = lib.getAPIbase()

findUpperRankFromSpecies = (sp) ->
    Name.find {_id:sp.upper_id }, (err, genus)->

module.exports =
    document: (req, res) ->
        res.header("Content-Type", "application/json; charset=utf-8");
        res.json document:
            title:'とりAPIドキュメント'
            body:
                APIs: [{
                    API: "GET #{APIbase}"
                    description: 'このドキュメント'
                },{
                    API: "GET #{APIbase}/birds"
                    description: '日本で見られるすべての鳥について、名前Objectをすべて取得'
                },{
                    API: "GET #{APIbase}/birds/{:鳥の名前}"
                    description: '標準和名を指定して該当する種の名前Objectを取得'
                }]

    species: (req, res) ->
        res.header("Content-Type", "application/json; charset=utf-8");
        Name.find {rank:"species"}, (err, species) ->
            if err
                res.send err
            else
                res.json { species }


    identifySpecies: (req, res) ->
        res.header("Content-Type", "application/json; charset=utf-8");
        Name.find {rank:"species", ja:req.params.identifier}, (err, result) ->
            # resultが複数帰ってきた場合は？
            if (err)
                res.send err
            else
                lib.attachUpperTaxonomies result[0], result[0].upper_id, (body) ->
                    res.json body
