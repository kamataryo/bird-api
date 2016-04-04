mongoose = require 'mongoose'
Schema = mongoose.Schema

OrderSchema = new Schema {
    name: String
    ac_name: String
}

FamilySchema = new Schema {
    name: String
    ac_name: String
    order: {
        type: Schema.Types.ObjectId
        ref: 'Order'
    }
}

GeniusSchema = new Schema {
    name: String
    ac_name: String
    family: {
        type: Schema.Types.ObjectId
        ref: 'Family'
    }
}

BirdSchema = new Schema {
    name: String
    ac_name: String
    genius: {
        type: Schema.Types.ObjectId
        ref: 'Genius'
    }
}

SubSpeciesSchema = new Schema {
    name: String
    ac_name: String
    species: {
        type: Schema.Types.ObjectId
        ref: 'Bird'
    }
}
module.exports =
    Order:      mongoose.model 'Order', OrderSchema
    Family:     mongoose.model 'Family', FamilySchema
    Genius:     mongoose.model 'Genius', GeniusSchema
    Bird:       mongoose.model 'Bird', BirdSchema
    SubSpecies: mongoose.model 'SubSpecies', SubSpeciesSchema
