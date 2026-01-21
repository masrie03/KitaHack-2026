const axios = require("axios");
const FormData = require("form-data");
const fs = require("fs");
const path = require("path");

// PDF location
const filePath = path.join(__dirname, "../Dataset/source2.pdf");

// Firebase emulator URL (functions)
const url = "http://127.0.0.1:5001/kitahack-byteme-backend/us-central1/parsePolicy";

if (!fs.existsSync(filePath)) {
  console.error("PDF not found at", filePath);
  process.exit(1);
}

const form = new FormData();
//form.append("file", fs.createReadStream(filePath));

// Add path.basename(filePath) as the 3rd argument
form.append("file", fs.createReadStream(filePath), path.basename(filePath));
axios.post(url, form, { headers: form.getHeaders() })
  .then(res => console.log("Response:", res.data))
  .catch(err => {
    if (err.response) console.error("Error response:", err.response.data);
    else console.error("Error:", err.message);
  });
