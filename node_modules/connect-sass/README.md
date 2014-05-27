Connect/express middelware for rendering SASS/SCSS. Install via `npm`:

    npm install connect-sass

Basic usage is as follows:

    express = require('express');
    sass = require('connect-sass');

    app = express();
    app.use('/css/app.css', sass.serve('sass/app.sass'));
    app.listen(3000);

This middleware will start watching directory of passed SASS/SCSS file for
changes and rebuild CSS accordingly caching the result for future requests.

You should never use this middleware in production — use nginx for serving
pre-built CSS assets to a browser.
