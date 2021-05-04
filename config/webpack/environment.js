const { environment } = require('@rails/webpacker')

// specific
const webpack = require('webpack');
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  bootstrap: 'bootstrap'
}));
// specific

module.exports = environment
