# external modules
express    = require 'express'
app        = express()
router     = express.Router()
bodyParser = require 'body-parser'
mongoose   = require 'mongoose'
morgan     = require 'morgan'
_          = require 'underscore'

# internal modules
routes     = require './routes/'
Name       = require './models/'
util       = require './utilities'

app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()
app.use morgan('common',immediate:true)
#app.use express.static(__dirname + '/public')

# router.use (req, res, next) ->
#     console.log 'Detect access.'
#     console.log Object.keys req
#     console.log req.connection
#     next()

app.use util.getAPIbase(), router
router.route('/').get routes.doc
router.route('/:ranks').get routes.ranks
router.route('/birds/:identifier').get routes.identifySpecies


mongoose.connect 'mongodb://localhost/birdAPI'
port = process.env.PORT || util.port
app.listen port,'localhost', ->
    console.log "server start listenning.."
