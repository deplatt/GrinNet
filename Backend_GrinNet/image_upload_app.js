/**
 * Local image upload server for GrinNet.
 * Accepts common image formats, resizes large images, and serves static content.
 *
 * @routes
 * GET    /uploads/:filename     Serve uploaded static image
 * POST   /upload                Upload and (if needed) resize an image
 * DELETE /image/:filename       Delete a stored image
 */

const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const sharp = require('sharp');
const config = require('./config');

// ========== Configurable Logging Setup ==========
const logToFile = false; // Set to true to log to file
const logFilePath = path.join(__dirname, 'image-server.log');

function logger(message) {
  const logEntry = `[${new Date().toISOString()}] ${message}`;
  if (logToFile) {
    fs.appendFileSync(logFilePath, logEntry + '\n');
  } else {
    console.log(logEntry);
  }
}
// =================================================

const app = express();

const UPLOAD_DIR = path.join(__dirname, 'uploads');
const MAX_DIMENSION = 480;
const PORT = config.UPLOAD_PORT;

// Create the upload directory if it doesn't exist
if (!fs.existsSync(UPLOAD_DIR)) {
  fs.mkdirSync(UPLOAD_DIR);
  logger('Created uploads directory');
}

// Serve images statically from /uploads
app.use('/uploads', express.static(UPLOAD_DIR));

// Define supported MIME types
const supportedMimeTypes = [
  'image/jpeg', 'image/png', 'image/gif',
  'image/webp', 'image/bmp', 'image/x-wbmp', 'image/x-ms-bmp'
];

// Configure multer storage
const storage = multer.diskStorage({
  destination: (_, __, cb) => cb(null, UPLOAD_DIR),
  filename: (_, file, cb) => {
    const timestamp = Date.now();
    const sanitized = file.originalname.replace(/\s+/g, '-');
    cb(null, `${timestamp}-${sanitized}`);
  },
});

const upload = multer({
  storage,
  fileFilter: (_, file, cb) => {
    if (supportedMimeTypes.includes(file.mimetype)) cb(null, true);
    else cb(null, false);
  }
}).single('image');

// POST /upload
app.post('/upload', (req, res) => {
  upload(req, res, async (err) => {
    if (err || !req.file) {
      logger(`Image upload failed: ${err ? err.message : 'Invalid or missing file'}`);
      return res.status(400).json({ error: 'Invalid image or upload error.' });
    }

    const inputPath = req.file.path;
    const outputPath = path.join(UPLOAD_DIR, 'resized-' + req.file.filename);

    try {
      const image = sharp(inputPath);
      const metadata = await image.metadata();

      const shouldResize = metadata.width > MAX_DIMENSION || metadata.height > MAX_DIMENSION;

      if (shouldResize) {
        await image.resize({ width: MAX_DIMENSION, height: MAX_DIMENSION, fit: 'inside' }).toFile(outputPath);
        fs.unlinkSync(inputPath);
        logger(`Uploaded and resized image: ${req.file.filename}`);
      } else {
        fs.renameSync(inputPath, outputPath);
        logger(`Uploaded image without resizing: ${req.file.filename}`);
      }

      res.status(200).json({ filename: path.basename(outputPath) });
    } catch (e) {
      logger(`[ERROR] Failed to process image: ${e.message}`);
      res.status(500).json({ error: 'Image processing failed: ' + e.message });
    }
  });
});

// DELETE /image/:filename
app.delete('/image/:filename', (req, res) => {
  const filePath = path.join(UPLOAD_DIR, req.params.filename);
  if (fs.existsSync(filePath)) {
    fs.unlinkSync(filePath);
    logger(`Deleted image: ${req.params.filename}`);
    res.status(200).json({ message: 'Image deleted.' });
  } else {
    logger(`Attempted to delete non-existent image: ${req.params.filename}`);
    res.status(404).json({ error: 'Image not found.' });
  }
});

// Start server
if (require.main === module) {
  app.listen(PORT, () => {
    logger(`Image Upload Server running on port ${PORT}`);
  });
}

module.exports = app;
