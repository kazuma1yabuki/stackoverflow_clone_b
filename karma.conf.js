const webpackConfig = require('./webpack.config');

module.exports = function (config) {
  config.set({
    basePath: '',
    frameworks: ['mocha'],
    files: [
      'js_test/**/*.spec.js',
    ],
    webpack: Object.assign({}, webpackConfig, { devtool: 'inline-source-map' }),
    exclude: [
    ],
    preprocessors: {
      'js_test/**/*.spec.js': ['webpack'],
      'web/static/main.js': ['webpack'],
    },
    reporters: ['progress'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['jsdom'],
    singleRun: false,
    concurrency: Infinity,
  });
};
