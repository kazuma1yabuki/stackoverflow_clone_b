const path = require('path');

const isDevelopment = (process.env.NODE_ENV === undefined || process.env.NODE_ENV === 'development');

module.exports = {
  mode: isDevelopment ? 'development' : 'production',
  // debugger statement makes misplaced break point on Chrome devtools on cheap-module-eval-source-map
  devtool: isDevelopment ? 'cheap-eval-source-map' : undefined,
  entry: './web/static/main.js',
  output: {
    path: `${__dirname}/priv/static`,
    filename: '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          { loader: 'style-loader' },
          { loader: 'css-loader' },
        ],
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: [
          { loader: 'babel-loader' },
        ],
      },
      {
        test: /\.vue$/,
        use: [
          { loader: 'vue-loader' }
        ],
      },
    ],
  },
  resolve: {
    alias: {
      vue$: 'vue/dist/vue.esm.js',
      '@': path.resolve(__dirname, 'web/static'),
    },
    extensions: ['.js', '.vue'],
  },
  devServer: {
    port: 8082,
    publicPath: '/priv/static',
  },
  node: { // https://github.com/vuejs/vue-test-utils/issues/440
    fs: 'empty',
    module: 'empty',
  },
};
