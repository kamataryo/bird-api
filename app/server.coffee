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
app.use morgan('common',immediate:true) # morgan setting default

# set routers up
app.use util.getAPIbase(), router
router.route('/').get                      routes.doc
router.route('/inclusion').get             routes.findInclusion

router.route('/distributions').get              routes.getDistributions
router.route('/distributions/:identifier').get  routes.getDistributionsOf
router.route('/distributions/:identifier').post routes.postDdistributionsOf

router.route('/existence/:identifier').get routes.askExistence
router.route('/:ranks').get                routes.ranks
router.route('/:ranks/:identifier').get    routes.identifyName

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

# start listening
mongoose.connect 'mongodb://localhost/birdAPI'
port = process.env.PORT || util.port

app.listen port,'localhost', ->
    console.log "server start listenning at #{port}.."
