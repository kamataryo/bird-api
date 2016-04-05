mongoose = require 'mongoose'
Schema = mongoose.Schema
upperRank = false

ranks = [
    "Order"
    "Family"
    "Genus"
    "Species"
    "Subspecies"
]

for rank in ranks
    args =
        alien: Boolean
        ac: String
        ja: String
        upper:
            type: Schema.Types.ObjectId
            ref: upperRank

    module.exports[rank] = mongoose.model rank, new Schema args
    upperRank = rank
