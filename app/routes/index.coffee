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
