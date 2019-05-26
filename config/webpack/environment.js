const { environment } = require('@rails/webpacker');
const webpack = require('webpack');

const erb =  require('./loaders/erb');
environment.loaders.prepend('erb', erb);

// jQuery
environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  jquery: 'jquery'
}));
// jQuery

module.exports = environment
