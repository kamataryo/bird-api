express    = require 'express'
app        = express()
router     = express.Router()
bodyParser = require 'body-parser'
mongoose   = require 'mongoose'

# require models
Taxonomies = require './app/models/models'
Order      = Taxonomies.Order
Family     = Taxonomies.Family
Genus      = Taxonomies.Genus
Bird       = Taxonomies.Species
Subspecies = Taxonomies.Subspecies

# require routers


mongoose.connect 'mongodb://localhost/birdAPI'
port = process.env.PORT || 3000


app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()
app.use '/api', router

app.listen port
console.log 'listen on port ' + port



router.use (req, res, next) ->
    console.log 'Something is happening.'
    next()


router.get '/', (req, res) ->
    res.json message: 'Successfully posted a test message!'






router.route '/birds'
    .post (req, res) ->
        bird = new Bird()
        bird.name = req.body.name
        bird.ac_name = req.body.ac_name
        bird.save (err) ->
            if err
                res.send err
            else
                res.json {message: 'Bird created!'}

    .get (req, res) ->
        Bird.find (err, birds) ->
            if err
                res.send err
            else
                res.json birds


router.route '/birds/:bird_id'
    .get (req, res) ->
        Bird.findById req.params.bird_id, (err, bird) ->
            if err
                res.send err
            else
                # ?field=name,ac_nameなどに対応させる
                res.json {
                    query:req.query
                    body:bird
                }

router.route '/birds/:bird_id/subspecies'
    .get (req, res) ->
        Bird.findById req.params.bird_id, (err, bird) ->
            if err
                res.send err
            else
                Subspecies.findById bird.genius_id (err, genius) ->
                if err
                    res.send err
                else
                    res.json genus
