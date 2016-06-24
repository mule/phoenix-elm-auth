exports.config = {
    // See http://brunch.io/#documentation for docs.
    files: {
        javascripts: {
            joinTo: {
              //"js/init.js": /^(web\/static\/js\/init\.js)/  
              //"js/elmApp.js": /^(web\/static\/elmBuild)/,
              "js/app.js": /^(web\/static\/js)/,
              "js/vendor.js": /^(node_modules)/  
            },
            order: {
                before: [ "web/static/js/main.js", "web/static/js/app.js" ]
            }


            // To use a separate vendor.js bundle, specify two files path
            // https://github.com/brunch/brunch/blob/stable/docs/config.md#files
            // joinTo: {
            //  "js/app.js": /^(web\/static\/js)/,
            //  "js/vendor.js": /^(web\/static\/vendor)|(deps)/
            // }
            //
            // To change the order of concatenation of files, explicitly mention here
            // https://github.com/brunch/brunch/tree/master/docs#concatenation
            // order: {
            //   before: [
            //     "web/static/vendor/js/jquery-2.1.1.js",
            //     "web/static/vendor/js/bootstrap.min.js"
            //   ]
            // }
        },
        stylesheets: {
            joinTo: "css/app.css"
        },
        templates: {
            joinTo: "js/app.js"
        }
    },

    conventions: {
        // This option sets where we should place non-css and non-js assets in.
        // By default, we set this to "/web/static/assets". Files in this directory
        // will be copied to `paths.public`, which is "priv/static" by default.
        assets: [
            /^(web\/static\/assets)/
        ],
        ignored: /^(web\/elm\/elm-stuff)/
    },

    // Phoenix paths configuration
    paths: {
        // Dependencies and current project directories to watch
        watched: [
            "web/static",
            "test/static",
            "web/elm/"
        ],

        // Where to compile files to
        public: "priv/static",
       
    },

    // Configure your plugins
    plugins: {
        elmBrunch: {
            elmFolder: "web/elm",
            mainModules: ["Main.elm"],
            outputFolder: "../static/js/",
            makeParameters: ['--warn']
        },
        babel: {
            // Do not use ES6 compiler in vendor code
            ignore: [
                /web\/static\/js\/main\.js/
             ]
        },
        sass: {
            mode: 'native'
        }
        // copycat: {
        //     "fonts": ["node_modules/materialize-css/fonts"],
        //     verbose: true, //shows each file that is copied to the destination directory
        //     onlyChanged: true //only copy a file if it's modified time has changed (only effective when using brunch watch)
        // }
    },

    modules: {
        autoRequire: {
            "js/app.js": ["web/static/js/app"]
        }
    },

    npm: {
        enabled: true,
        // Whitelist the npm deps to be pulled in as front-end assets.
        // All other deps in package.json will be excluded from the bundle.
        whitelist: ["phoenix", "phoenix_html", "jquery", "tether", "bootstrap"],
        styles: {
            "bootstrap": ['dist/css']
        },

    globals: {
      $: 'jquery',
      jQuery: 'jquery',
      Tether: 'tether',
    }
    }
};
