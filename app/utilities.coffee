# app/lib

Name    = require './models'
_       = require 'underscore'

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


getAPIbase = ->
    "/v#{version}"

getAPIurl = (dir) ->
    "http://#{host}#{if port then ':' + port}#{getAPIbase()}/#{encodeURI dir}"

buildBiomen = (species, taxonomies) ->
    species = species.sc
    genus = ''
    for taxonomy in taxonomies
        if taxonomy.rank = 'genus'
            genus = taxonomy.sc
            break
    n = genus.length
    return genus[0].toUpperCase() + genus[1...n].toLowerCase() + ' ' + species.toLowerCase()

# find upper taxonomies from db
attachUpperTaxonomies = ({species, upper_id, taxonomies, fieldsAcceptable, callback}) ->

    Name.findById upper_id, (err, upper) ->
        upper = upper._doc
        upper_id = upper.upper_id

        taxonomies.push upper

        if upper_id?
            attachUpperTaxonomies {
                species
                taxonomies
                upper_id
                fieldsAcceptable
                callback
            }
        else
            biomen = buildBiomen species, taxonomies
            for taxonomy in taxonomies
                acceptFieldsInTaxonomy fieldsAcceptable, taxonomy
                acceptFieldsInTaxonomy fieldsAcceptable, species

            callback {species, biomen, taxonomies}


acceptFieldsInTaxonomy = (fieldsAcceptable, taxonomy) ->

    allFields = Object.keys taxonomy
    for field in allFields
        unless field in fieldsAcceptable then delete taxonomy[field]



# check if elements in array `A` equal that of `B`
atLeastContains = (A, B) ->
    for a in A
        for b in B
            if a is b then return true
    return false


parseQuery = (req) ->
    #parse `fields` query
    if req.query.fields?
        fields = req.query.fields
            .split ','
            .join ' '
    else
        fields = ''

    # parse `offset` query
    if req.query.offset?
        offset = parseInt req.query.offset
        if offset isnt offset
            offset = 0
        else
            if offset < 0 then offset = 0
    else
        offset = 0

    # parse `limit` query
    if req.query.limit?
        limit = parseInt req.query.limit
        if limit isnt limit
            limit = false
    else
        limit = false

    return { fields, offset, limit }


module.exports = {
    host
    port
    version
    getAPIbase
    getAPIurl
    attachUpperTaxonomies
    acceptFieldsInTaxonomy
    atLeastContains
    singular_for
    parseQuery
}
