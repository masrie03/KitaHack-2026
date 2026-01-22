const functions = require("firebase-functions");
const express = require("express");
const busboy = require("busboy");
const pdf = require("pdf-parse");
const cors = require("cors");
const { GoogleGenerativeAI } = require("@google/generative-ai");
const path = require('path');
const fs = require('fs');
require('dotenv').config();

const app = express();
app.use(cors({ origin: true }));

// Path to your CSV (if you're using it for RAG later)
const csvPath = path.join(__dirname, 'data', 'master_clauses.csv');
if (fs.existsSync(csvPath)) {
    console.log("✅ CUAD Dataset loaded successfully.");
} else {
    console.warn("⚠️ CUAD Dataset not found at:", csvPath);
}

const CUAD_LOAN_CHECKLIST = {
  "Effective Date": "When the loan is disbursed and interest begins to accrue.",
  "Repayment Trigger": "The event that starts the repayment (e.g., '6 months after graduation').",
  "Interest Rate / Profit Rate": "The cost of the loan (e.g., 1% for PTPTN, or 4-6% for banks).",
  "Late Payment Penalty": "The 'Gharamah' or late fee (e.g., 1% per annum on the arrears).",
  "Governing Law": "Legal jurisdiction (usually Laws of Malaysia).",
  "Co-signer / Guarantor": "Who else is legally responsible if the student fails to pay."
};

// Initialize Gemini
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

/**
 * Adds a warning flag if the policy is close to expiring.
 */
function processClausesWithWarnings(clauses) {
  const today = new Date();
  const uniqueCategories = {};

  // 1. Deduplicate: Only keep the best/first find for each category
  clauses.forEach(item => {
    if (!uniqueCategories[item.category]) {
      uniqueCategories[item.category] = item;
    }
  });

  // 2. Map the unique items and add logic
  return Object.values(uniqueCategories).map(item => {
    item.status = "INFO"; 

    if (item.category === "Expiration Date" && item.date_found) {
      const expiryDate = new Date(item.date_found);
      const diffDays = Math.ceil((expiryDate - today) / (1000 * 60 * 60 * 24));

      if (diffDays < 0) {
        item.status = "EXPIRED";
        item.warning = "⚠️ Policy ended.";
      } else if (diffDays <= 60) { // 60 days is better for students to prepare
        item.status = "URGENT";
        item.warning = `⚠️ Ends in ${diffDays} days!`;
      } else {
        item.status = "ACTIVE";
      }
    }
    return item;
  });
}

/**
 * Analyzes PDF text using Gemini and CUAD benchmarks.
 */
async function analyzeWithGemini(text) {
    const model = genAI.getGenerativeModel({ 
        model: "gemini-2.5-flash",
        systemInstruction: "You are a legal auditor. Extract clauses based on the CUAD (Contract Understanding Atticus Dataset) standard. Be precise with dates and jurisdiction."
    });

    const generationConfig = {
        temperature: 0.1,
        maxOutputTokens: 8000,
        responseMimeType: "application/json",
    };

   const prompt = `
  You are a Financial Literacy Expert for Students. 
  Analyze this Loan Agreement using the CUAD-inspired checklist:
  ${Object.entries(CUAD_LOAN_CHECKLIST).map(([k, v]) => `- ${k}: ${v}`).join("\n")}

  ADDITIONAL CRITICAL DATA:
  - Find the 'Repayment Start' condition (e.g., 6 months after grad).
  - Check for 'Guarantor' requirements.
  - Look for 'First Class Honours' or 'Excellence' waivers (Malaysian specific).

  FORMAT: Return a JSON array of objects with "category", "clause", "explanation", and "risk_level" (Low, Medium, High).
  
  TEXT: ${text.substring(0, 15000)}
`;

    try {
        const result = await model.generateContent({
            contents: [{ role: "user", parts: [{ text: prompt }] }],
            generationConfig,
        });
        
        const rawText = result.response.text();
        const clauses = JSON.parse(rawText);
        
        return processClausesWithWarnings(clauses);
    } catch (error) {
        console.error("Gemini Analysis Error:", error);
        throw new Error("AI failed to parse legal clauses: " + error.message);
    }
}

app.post("/", (req, res) => {
    const bb = busboy({ headers: req.headers });
    let chunks = [];
    let fileName = "unknown.pdf";

    bb.on("file", (name, file, info) => {
        fileName = info.filename;
        file.on("data", (data) => chunks.push(data));
    });

    bb.on("finish", async () => {
        try {
            if (chunks.length === 0) {
                return res.status(400).json({ error: "No file content uploaded." });
            }

            const fileBuffer = Buffer.concat(chunks);
            const pdfData = await pdf(fileBuffer);
            
            console.log(`Processing file: ${fileName}`);
            
            const clauses = await analyzeWithGemini(pdfData.text);

            res.json({ 
                status: "success", 
                filename: fileName, 
                benchmark: "Cuad-v1 Standard",
                clauses: clauses 
            });
        } catch (error) {
            console.error("Endpoint Error:", error);
            res.status(500).json({ status: "error", error: error.message });
        }
    });

    // In Firebase Functions, the raw body is needed for busboy
    if (req.rawBody) {
        bb.end(req.rawBody);
    } else {
        req.pipe(bb);
    }
});

exports.parsePolicy = functions.https.onRequest(app);