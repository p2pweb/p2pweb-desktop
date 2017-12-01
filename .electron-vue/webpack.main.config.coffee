
process.env.BABEL_ENV = 'main'
isProduction = (process.env.NODE_ENV == 'production')


path = require('path')
{ dependencies } = require('../package.json')
webpack = require('webpack')


mainConfig = {
  entry: {
    main: path.join(__dirname, '../src/main/index.js')
  },
  externals: [
    ...Object.keys(dependencies || {})
  ]
  module: {
    rules: [
      { test: /\.coffee$/, loader: "coffee-loader" },
      {
        test: /\.js$/,
        use: 'babel-loader',
        exclude: /node_modules/
      },
      {
        test: /\.node$/,
        use: 'node-loader'
      }
    ]
  },
  node: {
    __dirname: not isProduction
    __filename: not isProduction
  },
  output: {
    filename: '[name].js',
    libraryTarget: 'commonjs2',
    path: path.join(__dirname, '../dist/electron')
  },
  plugins: [
    new webpack.NoEmitOnErrorsPlugin()
  ],
  resolve: {
    extensions: ['.js', '.json', '.node']
  },
  target: 'electron-main'
}

if isProduction
  BabiliWebpackPlugin = require('babili-webpack-plugin')
  mainConfig.plugins.push(
    new BabiliWebpackPlugin(),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': '"production"'
    })
  )
else
  mainConfig.plugins.push(
    new webpack.DefinePlugin({
      '__static': '"'+path.join(__dirname, '../static').replace(/\\/g, '\\\\')+'"'
    })
  )

module.exports = mainConfig
