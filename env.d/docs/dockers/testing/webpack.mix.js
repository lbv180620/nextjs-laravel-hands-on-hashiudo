const mix = require("laravel-mix");

const glob = require("glob");

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel applications. By default, we are compiling the CSS
 | file for the application as well as bundling up all the JS files.
 |
 */

glob.sync("resources/js/**/*.js", {
    cwd: "./",
    ignore: ["js/bootstrap.js"],
}).map(function (file) {
    mix.js(file, "public/js");
});

mix.postCss("resources/css/app.css", "public/css", [
    require("postcss-import"),
    require("tailwindcss"),
    require("autoprefixer"),
])
    .browserSync({
        proxy: {
            target: "http://localhost:8080",
        },
        files: ["./resources/**/*", "./public/**/*"],
        open: true,
        reloadOnRestart: true,
    })
    .disableNotifications();

if (mix.inProduction()) {
    mix.version();
}
