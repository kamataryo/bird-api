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
    if upperRank
        args[upperRank] =
            type: Schema.Types.ObjectId
            ref: upperRank
    upperRank = rank.toLowerCase()
    module.exports[rank] = mongoose.model rank, new Schema args
