# app/lib

Name    = require './models'
_       = require 'underscore'

# meta information settings
STAGE = 'development'
meta    = require('../package.json')
host    = meta.settings[STAGE].host
port    = meta.settings[STAGE].port
version = meta.version.split('.')[0]

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

buildBinomen = (species_sc, genus_sc) ->
    n = genus_sc.length
    return genus_sc[0].toUpperCase() + genus_sc[1...n].toLowerCase() + ' ' + species_sc.toLowerCase()

# find upper taxonomies from db
attachUpperTaxonomies = ({name, binomen, taxonomies, reference, fields, callback}) ->
    unless taxonomies? then taxonomies = []

    promise1 = Name
        .findById reference.upper_id
        .select fields
        .exec()

    promise2 = Name
        .findById reference.upper_id
        .exec()

    Promise.all [promise1, promise2]
        .then ([upper, ref2Upper]) ->

            if reference.rank is 'species'
                binomen = buildBinomen reference.sc, ref2Upper.sc

            upper_id = reference.upper_id
            if upper_id?
                taxonomies.push upper
                attachUpperTaxonomies {
                    name
                    binomen
                    taxonomies
                    reference:ref2Upper
                    fields
                    callback
                }
            else
                callback {name,binomen, taxonomies}




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

    # parse `content` query
    content = req.query.content
    unless content? then content = ''


    return { fields, offset, limit, content }


module.exports = {
    host
    port
    version
    getAPIbase
    getAPIurl
    attachUpperTaxonomies
    atLeastContains
    singular_for
    parseQuery
}
