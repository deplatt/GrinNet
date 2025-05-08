/**
 * Configuration constants for local development.
 * Modify values based on your DB setup.
 * 
 * @module config
 */

module.exports = {
  PORT: 3000, // express port
  DB_USER: 'grinnetadmin',
  DB_HOST: '127.0.0.1',
  DB_DATABASE: 'GrinNetDev',
  DB_PASSWORD: 'csc324AdminDropTheClass!',
  DB_PORT: 5432,
  UPLOAD_PORT: 4000 // image server port
};
