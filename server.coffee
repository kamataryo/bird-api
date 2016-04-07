express    = require 'express'
bodyParser = require 'body-parser'
mongoose   = require 'mongoose'
app        = express()
router     = express.Router()
routes     = require './app/routes/'
Name       = require './app/models/'
meta       = require('./package.json')
version    = meta.version.split('.')[0]
_          = require 'underscore'


mongoose.connect 'mongodb://localhost/birdAPI'
port = process.env.PORT || 3000


app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()
app.use "/#{version}", router

router.use (req, res, next) ->
    console.log 'Detect access.'
    next()

router.get '/', routes.docs
router.route('/index').get routes.index
router.route('/birds').get routes.species
router.route('/birds/:identifier').get routes.identifySpecies

app.listen port,'localhost', ->
    console.log "server #{meta.name} start listenning on port #{port}."
