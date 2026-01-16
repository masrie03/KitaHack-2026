const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");
const multer = require("multer");
const pdfParse = require("pdf-parse");

// Setup Express
const app = express();
app.use(cors({ origin: true }));

// Setup multer for file uploads
const upload = multer({ storage: multer.memoryStorage() });

// Mock Gemini API call (replace with real call later)
async function mockGeminiParse(text) {
  // Here we simulate clause extraction & scenario impacts
  return [
    {
      clause: "Clause 1: Data may be shared with third parties.",
      impact: {
        student: "Medium risk: personal info shared with university partners",
        parent: "Low risk: mostly irrelevant",
        intern: "High risk: may affect internship eligibility"
      },
      risk: "Medium"
    },
    {
      clause: "Clause 2: You agree to automatic attendance tracking.",
      impact: {
        student: "High risk: privacy concern",
        parent: "Low risk",
        intern: "Medium risk"
      },
      risk: "High"
    }
  ];
}

// Upload endpoint
app.post("/parsePolicy", upload.single("file"), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ error: "No file uploaded" });

    // Parse PDF text
    const dataBuffer = req.file.buffer;
    const pdfData = await pdfParse(dataBuffer);
    const text = pdfData.text;

    // Call mock Gemini
    const result = await mockGeminiParse(text);

    res.json({ clauses: result });
  } catch (error) {
    console.error("Error parsing PDF:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Export as Firebase Function
exports.parsePolicy = functions.https.onRequest(app);
