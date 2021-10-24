const Images = require('../models/images.model');
const tools = require('../services/tools');

exports.getImage = async function (req, res) {
    try {
        const filename = req.params.imageName;
        const imageDetails = await Images.retrieveImage(filename);
        if (imageDetails == null) {
            res.statusMessage = 'Not Found';
            res.status(404).send();
        } else {
            res.statusMessage = 'OK';
            res.status(200).contentType(imageDetails.mimeType).send(imageDetails.image);
        }
    } catch (err) {
        if (!err.hasBeenLogged) console.error(err);
        res.statusMessage = 'Internal Server Error';
        res.status(500).send();
    }
};

exports.setImage = async function (req, res) {
    const image = req.body;
    const imageName = req.params.imageName;
    // Find the file extension for this photo
    const mimeType = req.header('Content-Type');
    const fileExt = tools.getImageExtension(mimeType);
    if (fileExt === null) {
        res.statusMessage = 'Bad Request: photo must be image/jpeg, image/png, image/gif type, but it was: ' + mimeType;
        res.status(400).send();
        return;
    }

    if (req.body.length === undefined) {
        res.statusMessage = 'Bad request: empty image';
        res.status(400).send();
        return;
    }

    try {
        const filename = await Images.storeImage(image, imageName);
        if (filename) {
            res.statusMessage = 'Created';
            res.status(201).send();
        }
    } catch (err) {
        if (!err.hasBeenLogged) console.error(err);
        res.statusMessage = 'Internal Server Error';
        res.status(500).send();
    }
};



