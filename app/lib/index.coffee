# app/lib

Name    = require '../models/'

STAGE = 'development'
meta    = require('../../package.json')
host    = meta.settings[STAGE].host
port    = meta.settings[STAGE].port
version = meta.version.split('.')[0]

upper_for =
    family:     "order"
    genus:      "family"
    species:    "genus"
    subspecies: "species"

getAPIbase = -> "/v#{version}"

getAPIurl = (dir) ->
    "http://#{host}#{if port then ':' + port}#{getAPIbase()}/#{encodeURI dir}"


attachUpperTaxonomies = ({species, upper_id, taxonomies, fields, callback}) ->

    Name.findById upper_id, (err, upper) ->
        upper = upper._doc
        upper_id = upper.upper_id

        allFields = Object.keys upper
        for field in allFields
            unless field in fields then delete upper[field]

        taxonomies.push upper

        if upper_id?
            attachUpperTaxonomies {
                species
                taxonomies
                upper_id
                fields
                callback
            }
        else
            callback {species, taxonomies}


module.exports = {
    host
    port
    version
    getAPIbase
    getAPIurl
    attachUpperTaxonomies
}
