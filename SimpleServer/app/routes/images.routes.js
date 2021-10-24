const images = require('../controllers/images.controller');

module.exports = function (app) {
    app.route(app.rootUrl + '/images/:imageName')
        .get(images.getImage)
        .put(images.setImage);
};
