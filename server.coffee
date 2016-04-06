express    = require 'express'
bodyParser = require 'body-parser'
mongoose   = require 'mongoose'
app        = express()
router     = express.Router()
version    = require('./package.json').version.split('.')[0]
_          = require 'underscore'

# require models
ranks = require './app/models/models'
Order      = ranks.Order
Family     = ranks.Family
Genus      = ranks.Genus
Bird       = ranks.Species
Subspecies = ranks.Subspecies


getter = (Model) ->
    (req, res) ->
        Model.find (err, values) ->
            if err
                res.send err
            else
                res.json { test:Model, values }


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

router.route('/orders').get getter(Order)
router.route('/genuses').get getter(Genus)
router.route('/families').get getter(Family)
router.route('/birds').get getter(Bird)
#
# router.route '/birds/:bird_id'
#     .get (req, res) ->
#         Bird.findById req.params.bird_id, (err, bird) ->
#             if err
#                 res.send err
#             else
#                 res.json {
#                     query:req.query
#                     body:bird
#                 }
#
#
# router.route '/birds/:bird_id/subspecies'
#     .get (req, res) ->
#         Bird.findById req.params.bird_id, (err, bird) ->
#             if err
#                 res.send err
#             else
#                 Subspecies.find {species:bird.ac}, (err, subspecies) ->
#                 if err
#                     res.send err
#                 else
#                     res.json subspecies
