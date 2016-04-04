express    = require 'express'
app        = express()
bodyParser = require 'body-parser'
mongoose   = require 'mongoose'
router     = express.Router()
Models     = require './app/models'

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
        bird = new Models.Bird()
        bird.name = req.body.name
        bird.ac_name = req.body.ac_name
        bird.save (err) ->
            if err
                res.send err
            else
                res.json {message: 'Bird created!'}

    .get (req, res) ->
        Models.Bird.find (err, birds) ->
            if err
                res.send err
            else
                res.json birds


router.route '/birds/:bird_id'
    .get (req, res) ->
        Models.Bird.findById req.params.bird_id, (err, bird) ->
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
        Models.Bird.findById req.params.bird_id, (err, bird) ->
            if err
                res.send err
            else
                Models.Subspecies.findById bird.genius_id (err, genius) ->
                if err
                    res.send err
                else
                    res.json genus
