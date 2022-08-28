const { watch } = require('gulp');
const browserSync = require('browser-sync').create();

const startServer = () => {
    browserSync.init({
        proxy: 'localhost:8080',
    });

    watch('./').on('change', browserSync.reload);
}

exports.s = startServer;
