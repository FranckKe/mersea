'use strict'

const merge = require('webpack-merge')
const prodEnv = require('./prod.env')

module.exports = merge(prodEnv, {
  NODE_ENV: '"development"',
  API_URL: '"http://localhost:3000"',
  MAPBOX_TOKEN: '"pk.eyJ1IjoiZnJhbmNrayIsImEiOiJjamc5ODhrazUzaXlvMndvaDBzMnZoZXF6In0.ThvS99eoVrbmTC_KAmv_6w"'
})
