Name = require '../models/'

module.exports =
    docs: (req, res) ->
        res.json message: 'Successfully posted a test message!'

    index: (req, res) ->
        Name.find (err, names) ->
            if err
                res.send err
            else
                res. json names

    species: (req, res) ->
        Name.find {rank:"species"}, (err, species) ->
            if err
                res.send err
            else
                res. json species

    identifySpecies: (req, res) ->
        Name.find {rank:"species", ja:req.params.identifier}, (err, species) ->
            if (err)
                res.send err
            else
                res.json species
