# external modules
fs         = require 'fs'
express    = require 'express'
app        = express()
router     = express.Router()
bodyParser = require 'body-parser'
mongoose   = require 'mongoose'
morgan     = require 'morgan'
_          = require 'underscore'

# internal modules
routes     = require './routes'
util       = require './utilities'

# load and configure express plugins
app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()
app.use morgan('common',immediate:true)
###
# morgan setting and something
app.use express.static(__dirname + '/public')
router.use (req, res, next) ->
    console.log 'Detect access.'
    console.log Object.keys req
    console.log req.connection
    next()
###

# set routers up
app.use util.getAPIbase(), router
router.route('/').get routes.doc
router.route('/:ranks').get routes.ranks
router.route('/birds/:identifier').get routes.identifySpecies
router.route '/birds/:identifier/distributions'
    .get routes.birdFoundAt
    .post foundBird

# start listening
mongoose.connect 'mongodb://localhost/birdAPI'
port = process.env.PORT || util.port

###
# http2 settings
options =
    key: fs.readFileSync ''
    cert: fs.readFileSync ''
require('http2')
   .createServer options, app
   .listen port,'localhost', ->
        console.log "server start listenning.."
###

app.listen port,'localhost', ->
    console.log "server start listenning.."
