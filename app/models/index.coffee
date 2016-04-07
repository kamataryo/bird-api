mongoose = require 'mongoose'
Schema   = mongoose.Schema
module.exports = mongoose.model 'Name', new Schema {
    sc: String
    ja: String
    rank: String
    upper:
        type: Schema.Types.ObjectId
        ref: 'Name'
    alien: Boolean
}
