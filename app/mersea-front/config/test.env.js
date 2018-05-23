'use strict'

const merge = require('webpack-merge')
const devEnv = require('./dev.env')

module.exports = merge(devEnv, {
  NODE_ENV: '"testing"',
  API_URL: '"http://localhost:3000"',
  MAPBOX_TOKEN: '"pk.eyJ1IjoiZnJhbmNrayIsImEiOiJjamc5ODhrazUzaXlvMndvaDBzMnZoZXF6In0.ThvS99eoVrbmTC_KAmv_6w"'
})
