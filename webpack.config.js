const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const VueLoaderPlugin = require('vue-loader/lib/plugin');

const ENTRY_FOLDER = './web/webroot/WEB-INF/_ui-src/responsive';
const LIB_FOLDER = `${ENTRY_FOLDER}/lib/ybase-0.1.0`;
const THEMES_FOLDER = `${ENTRY_FOLDER}/themes`;
const APP_DIST_FOLDER = './web/webroot/_ui/responsive';

const plugins = [
  new MiniCssExtractPlugin({
    filename: 'css/[name].bundle.css',
    chunkFilename: 'css/[id].bundle.css'
  }),
  new VueLoaderPlugin()
];

const commonConfigs = {
  plugins,
  stats: {
    children: process.env.NODE_ENV === 'development' ? true : false
  },
  mode: process.env.NODE_ENV || 'production',
  devtool: process.env.NODE_ENV === 'development' ? 'inline-source-map' : false,
  optimization: {
    minimize: true,
    minimizer: ['...', new CssMinimizerPlugin()]
  },
  cache: {
    type: 'filesystem'
  },
  module: {
    rules: [
      {
        test: /\.(ts|tsx|js)$/,
        use: {
          loader: 'swc-loader',
          options: {
            jsc: {
              parser: {
                syntax: 'typescript',
                dynamicImport: true
              },
              target: 'es2015'
            }
          }
        }
      },
      {
        test: require.resolve('jquery'),
        loader: 'expose-loader',
        options: {
          exposes: ['$', 'jQuery']
        }
      },
      {
        test: /\.less$/,
        exclude: /node_modules\/|.vue\.less$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'postcss-loader',
          {
            loader: 'less-loader',
            options: {
              sourceMap: true
            }
          }
        ]
      },
      {
        test: /\.vue.less$/,
        exclude: /node_modules/,
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: {
              sourceMap: true
            }
          },
          'postcss-loader',
          {
            loader: 'less-loader',
            options: {
              sourceMap: true
            }
          }
        ]
      },
      {
        test: /\.vue$/,
        loader: 'vue-loader'
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf|svg)$/i,
        exclude: /node_modules/,
        type: 'asset/resource'
      }
    ]
  },
  resolve: {
    extensions: ['*', '.tsx', '.ts', '.vue', '.js', '.less'],
    alias: {
      vue$: 'vue/dist/vue.esm.js'
    }
  }
};

module.exports = [
  {
    entry: {
      plugins: `${LIB_FOLDER}/js/plugins.ts`,
      base: `${LIB_FOLDER}/js/index.ts`,
      polyfill: `${LIB_FOLDER}/js/polyfill.ts`,
      register: `${LIB_FOLDER}/js/pages/Register.ts`,
      verticalTabs: `${LIB_FOLDER}/js/components/VerticalTabs/VerticalTabs.ts`,
      cart: `${LIB_FOLDER}/js/pages/CartPage.ts`,
      checkout: `${LIB_FOLDER}/js/pages/CheckoutPage.ts`,
      plp: `${LIB_FOLDER}/js/pages/ProductListingPage.ts`,
      loadingPage: `${LIB_FOLDER}/less/pages/loadingPage.less`,
      verticalTabsComp: `${LIB_FOLDER}/less/components/vertical-tabs.less`,
      style: `${THEMES_FOLDER}/brakes/less/style.less`
    },
    output: {
      path: path.resolve(__dirname, `${APP_DIST_FOLDER}/theme-brakes`),
      filename: 'js/[name].bundle.js',
      sourceMapFilename: '[file].map',
      assetModuleFilename: 'fonts/[name][ext]'
    },
    ...commonConfigs
  },
  // Countrychoice theme
  {
    entry: {
      style: `${THEMES_FOLDER}/countrychoice/less/style.less`
    },
    output: {
      path: path.resolve(__dirname, `${APP_DIST_FOLDER}/theme-countrychoice`),
      filename: 'js/[name].bundle.js',
      sourceMapFilename: '[file].map',
      assetModuleFilename: 'fonts/[name][ext]'
    },
    ...commonConfigs
  }
];
