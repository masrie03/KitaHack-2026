const functions = require("firebase-functions");
const express = require("express");
const busboy = require("busboy");
const pdf = require("pdf-parse");
const cors = require("cors");
const { GoogleGenerativeAI } = require("@google/generative-ai");
require('dotenv').config();

const app = express();
app.use(cors({ origin: true }));

// Initialize Gemini
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

async function analyzeWithGemini(text) {
  // Use System Instructions to define the persona and rules
  const model = genAI.getGenerativeModel({ 
    model: "gemini-2.5-flash",
    systemInstruction: "You are a legal assistant. You must always return a JSON array of objects, even if the text is short. Each object must have 'clause' and 'explanation' keys.",
  });

  // Use a simpler config to avoid empty returns
  const generationConfig = {
    temperature: 0.1, // Low temperature for consistency
    topP: 0.95,
    maxOutputTokens: 2048,
    responseMimeType: "application/json",
  };

  const prompt = `
    TASK: Extract exactly 2 important clauses from the insurance text provided.
    FORMAT: Return a JSON array.
    TEXT: ${text.substring(0, 20000)}
  `;

  try {
    const result = await model.generateContent({
      contents: [{ role: "user", parts: [{ text: prompt }] }],
      generationConfig,
    });

    const response = result.response;
    const responseText = response.text();
    
    // Safety check: parse and ensure it's not empty
    const parsed = JSON.parse(responseText);
    
    // If the AI still gives [], return a fallback so you can see it's working
    if (Array.isArray(parsed) && parsed.length === 0) {
      return [{ clause: "Debug", explanation: "AI returned empty array. Check PDF text content." }];
    }
    
    return parsed;
  } catch (error) {
    console.error("Gemini Error:", error);
    return [{ clause: "Error", explanation: error.message }];
  }
}

app.post("/", (req, res) => {
  const bb = busboy({ headers: req.headers });
  let chunks = [];
  let fileName = "unknown.pdf"; // Default fallback

  bb.on("file", (name, file, info) => {
    // Correctly extract filename from the info object
    fileName = info.filename;
    file.on("data", (data) => chunks.push(data));
  });

  bb.on("finish", async () => {
    try {
      const fileBuffer = Buffer.concat(chunks);
      const pdfData = await pdf(fileBuffer);

      // DEBUG: See the first 100 characters of the PDF
      console.log("PDF Text Preview:", pdfData.text.substring(0, 100).replace(/\n/g, " "));
      
      // Call real Gemini (or keep mockGeminiParse if testing)
      const clauses = await analyzeWithGemini(pdfData.text);

      // Your requested output format
      res.json({ 
        status: "success", 
        filename: fileName, 
        clauses: clauses 
      });
    } catch (error) {
      console.error("Error:", error);
      res.status(500).json({ error: error.message });
    }
  });

  bb.end(req.rawBody);
});

exports.parsePolicy = functions.https.onRequest(app);