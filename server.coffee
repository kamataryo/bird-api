express    = require 'express'
bodyParser = require 'body-parser'
mongoose   = require 'mongoose'
app        = express()
router     = express.Router()
routes     = require './app/routes'
version    = require('./package.json').version.split('.')[0]
_          = require 'underscore'

# require models
Name = require './app/models/name'

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

router.get '/', routes.docs
router.route('/index').get routes.index
