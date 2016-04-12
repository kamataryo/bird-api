# app/lib
Name    = require './models'

# meta information settings
STAGE = 'development'
meta    = require('../package.json')
host    = meta.settings[STAGE].host
port    = meta.settings[STAGE].port
version = meta.version.split('.')[0]


# modules to export

## taxonomies relationships
upper_for =
    family:     'order'
    genus:      'family'
    species:    'genus'
    subspecies: 'species'
## taonomy idioms
singular_for =
    orders:     'order'
    families:   'family'
    genuses:    'genus'
    species:    'species'
    birds:      'species'  # alias
    subspecies: 'subspecies'


getAPIbase = -> "/v#{version}"

getAPIurl = (dir) ->
    "http://#{host}#{if port then ':' + port}#{getAPIbase()}/#{encodeURI dir}"

# find upper taxonomies from db
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


# check if elements in array `A` equal that of `B`
atLeastContains = (A, B) ->
    for a in A
        for b in B
            if a is b then return true
    return false


module.exports = {
    host
    port
    version
    getAPIbase
    getAPIurl
    attachUpperTaxonomies
    atLeastContains
    singular_for
}