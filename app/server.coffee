# external
express    = require 'express'
app        = express()
router     = express.Router()

bodyParser = require 'body-parser'
mongoose   = require 'mongoose'
_          = require 'underscore'

# internal
routes     = require './routes/'
Name       = require './models/'
lib        = require './lib/'

mongoose.connect 'mongodb://localhost/birdAPI'
port = process.env.PORT || lib.port


app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()
app.use lib.getAPIbase(), router


router.use (req, res, next) ->
    console.log 'Detect access.'
    res = {
        message: "Not Found"
        documentation_url: lib.getAPIurl ''
    }
    next()

router.route('/').get routes.document
router.route('/:ranks').get routes.ranks
router.route('/birds/:identifier').get routes.identifySpecies

app.listen port,'localhost', ->
    console.log "server start listenning.."
