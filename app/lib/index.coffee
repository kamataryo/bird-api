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


attachUpperTaxonomies = (species, upper_id, callback) ->

    unless species.taxonomies? then species.taxonomies = []

    Name.findById upper_id, (err, name) ->
        species.taxonomies.push name
        if name.upper_id?
            upper_id = name.upper_id
            attachUpperTaxonomies species, upper_id, callback
        else
            callback {species:species, taxonomies:species.taxonomies}


module.exports = {
    host
    port
    version
    getAPIbase
    getAPIurl
    attachUpperTaxonomies
}
