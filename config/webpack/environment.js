const { environment } = require('@rails/webpacker')
const erb =  require('./loaders/erb')

// specific
const webpack = require('webpack');
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery'
}));
// specific

environment.loaders.prepend('erb', erb)
module.exports = environment
