Name    = require '../models/'
apibase = require('../lib/').getapibase()

findUpperRankFromSpecies = (sp) ->
    Name.find {_id:sp.upper_id }, (err, genus)->



module.exports =
    document: (req, res) ->
        res.header("Content-Type", "application/json; charset=utf-8");
        res.json document:
            title:'とりAPIドキュメント'
            body:
                APIs: [{
                    API: "GET #{apibase}"
                    description: 'このドキュメント'
                },{
                    API: "GET #{apibase}/birds"
                    description: '日本で見られるすべての鳥について、名前Objectをすべて取得'
                },{
                    API: "GET #{apibase}/birds/鳥の名前"
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
        console.log req.params
        Name.find {rank:"species", ja:req.params.identifier}, (err, sp) ->
            Name.findById sp.upper_id, (err, genus) ->
                if (err)
                    res.send err
                else
                    res.json { species:sp }
