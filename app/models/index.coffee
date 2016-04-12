mongoose = require 'mongoose'
Schema   = mongoose.Schema
module.exports =
    Name: mongoose.model 'Name', new Schema {
        sc: String
        ja: String
        rank: String
        upper_id: String
        alien: Boolean
    }
    Distribution: mongoose.model 'Distribution', new Schema {
        bird_id: String
        lat: Number
        lng: Number
        address: String
        created: Date
        modified: Date
    }
