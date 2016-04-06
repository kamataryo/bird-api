express    = require 'express'
bodyParser = require 'body-parser'
mongoose   = require 'mongoose'
app        = express()
router     = express.Router()
version    = require('./package.json').version.split('.')[0]
_          = require 'underscore'

# require models
Name = require './app/models/name'


poster = (Model) ->
    (req, res) ->
        model = new Model()
        model.ja = req.body.ja
        model.ac = req.body.ac
        model.save (err) ->
            if err
                res.send err
            else
                res.json {message: 'created!'}



mongoose.connect 'mongodb://localhost/birdAPI'
port = process.env.PORT || 3000


app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()
app.use "/#{version}", router
app.listen port
console.log 'listen on port ' + port

router.use (req, res, next) ->
    console.log 'Something is happening.'
    next()

router.get '/', (req, res) ->
    res.json message: 'Successfully posted a test message!'

router.route('/names').get (req, res) ->
    Name.find (err, names) ->
        if err
            res.send err
        else
            res.json names

router.route('/birds').get (req, res) ->
    Name.find {"rank":"species"}, (err, names) ->
        if err
            res.send err
        else
            res. json names
