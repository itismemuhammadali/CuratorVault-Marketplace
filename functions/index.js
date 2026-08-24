const { onRequest } = require("firebase-functions/v2/https");
const { logger } = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Sample Cloud Function endpoint
exports.apiHealth = onRequest((request, response) => {
  logger.info("Health check ping received!", { structuredData: true });
  response.json({
    status: "ok",
    service: "Vintage Vinne Cloud Functions",
    timestamp: new Date().toISOString()
  });
});
