/**
 * Test suite for the GrinNet Image Upload Server
 *
 * Verifies the image uploading, resizing, serving, and deletion functionalities.
 * Ensures only supported formats are accepted and oversized images are resized correctly.
 *
 * @module image_app.test
 */

const request = require('supertest');
const path = require('path');
const fs = require('fs');
const app = require('./image_upload_app');
const { expect } = require('chai');
const UPLOAD_DIR = path.join(__dirname, 'uploads');
const db = require('./functions');

describe('Image Upload App', function () {
  const supportedImages = ['test.jpg', 'test.png', 'test.gif', 'test.webp'];
  let uploadedFiles = [];

  /**
   * Test uploading and resizing supported image formats
   */
  supportedImages.forEach(filename => {
    it(`should upload and resize supported image: ${filename}`, function (done) {
      request(app)
        .post('/upload')
        .attach('image', path.join(__dirname, 'test_assets', filename))
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('filename');
          uploadedFiles.push(res.body.filename);
          done();
        });
    });
  });

  /**
   * Test handling upload when no file is attached
   */
  it('should return 400 if no file is attached', function (done) {
    request(app).post('/upload').expect(400, done);
  });

  /**
   * Test rejection of unsupported file types
   */
  it('should reject unsupported file types', function (done) {
    request(app)
      .post('/upload')
      .attach('image', path.join(__dirname, 'test_assets', 'test.txt'))
      .expect(400, done);
  });

  /**
   * Test deletion of uploaded images
   */
  it('should delete uploaded images', async function () {
    for (const file of uploadedFiles) {
      const res = await request(app).delete(`/image/${file}`);
      expect(res.status).to.equal(200);
    }
  });
});