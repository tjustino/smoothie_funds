const { environment } = require('@rails/webpacker')

// specific
const webpack = require('webpack');
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default']
}));
// specific

module.exports = environment
