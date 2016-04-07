STAGE = 'development'
meta    = require('../../package.json')
host    = meta.settings[STAGE].host
port    = meta.settings[STAGE].port
version = meta.version.split('.')[0]

module.exports = {
    host
    port
    version
    getapibase: -> "/v#{version}"
    url: (dir) -> "http://#{host}#{if port then ':' + port}/v#{version}/#{dir}"
}
