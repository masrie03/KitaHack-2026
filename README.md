For Prototype Documentation, please refer to "Documentation.pdf" <br>
Team:ByteMe <br>
AI Policy & Consent Auditor <br>
An AI-powered system that analyzes loan agreements and policy documents to improve comprehension, highlight risks, and provide actionable recommendations for students. <br>

# Problem Statement: <br>
Many students sign loan agreements and legal documents without fully understanding: <br>
* Financial penalties <br>
* Repayment conditions <br>
* Guarantor obligations <br>
* Hidden risk clauses <br>

Legal language is complex, dense, and difficult to interpret without professional training. <br>
This project aims to bridge that gap using AI-driven clause extraction, simplification, and risk evaluation. <br>

# Project Objective <br>
To develop an AI system that: <br>
Extracts critical clauses from loan agreements <br>
Explains them in simple, student-friendly language <br>
Classifies risk levels (Low / Medium / High) <br>
Provides actionable recommendations <br>
The system focuses on decision-support, not just summarization. <br>

# License <br>
This project is developed for academic / competition purposes. <br>

-- Getting started -- <br>

# Prerequisites <br>
Before begin,ensure you have the following installed:
1. Flutter SDK: Install Flutter
2. Java (JDK): Required to run Firebase Emulators.
3. Firebase CLI: Install Firebase CLI
4. An Editor (VS Code or Android Studio)

# Backend Setup(Firebase) <br>
The backend uses Google Gemini to analyze documents. You must provide your own API key to run it locally.
1. Get a Gemini API Key: Generate a free key at Google AI Studio.
2. Navigate to the backend:cd path/to/your/backend
3. Install Functions Dependencies:cd functions && npm install && cd ..
4. Start the Emulators:
   
Instead of a .env file for the backend, "inject" your key directly into the terminal session to keep it secure:
* MacOS/Linux:
GEMINI_API_KEY=your_actual_key_here firebase emulators:start
* Windows (PowerShell):
$env:GEMINI_API_KEY="your_actual_key_here"; firebase emulators:start

# Frontend Setup <br>
1. Create the file: In the root of the project, create a file named .env.
2. Add Configuration: Copy the following template and fill in the values (user may generate their own API keys):
API_KEY=your_api_key_here
BASE_URL=https://api.example.com
FIREBASE_MESSAGING_SENDER_ID=123456789
3. Verify Asset Registration: Ensure the .env file is listed in your pubspec.yaml:
assets:- .env

# Running the App <br>
1. flutter run 
