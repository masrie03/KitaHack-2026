For Prototype Documentation, please refer to "Documentation.pdf" <br>
Team:ByteMe <br>
AI Policy & Consent Auditor <br>
An AI-powered system that analyzes loan agreements and policy documents to improve comprehension, highlight risks, and provide actionable recommendations for students. <br>

Problem Statement: <br>
Many students sign loan agreements and legal documents without fully understanding: <br>
Financial penalties <br>
Repayment conditions <br>
Guarantor obligations <br>
Hidden risk clauses <br>

Legal language is complex, dense, and difficult to interpret without professional training. <br>
This project aims to bridge that gap using AI-driven clause extraction, simplification, and risk evaluation. <br>

Project Objective <br>
To develop an AI system that: <br>
Extracts critical clauses from loan agreements <br>
Explains them in simple, student-friendly language <br>
Classifies risk levels (Low / Medium / High) <br>
Provides actionable recommendations <br>
The system focuses on decision-support, not just summarization. <br>

License <br>
This project is developed for academic / competition purposes. <br>

Getting started <br>

Prerequisites <br>
Before begin,ensure you have the following installed:
*Flutter SDK: Install Flutter
*Dart SDK: (Included with Flutter)
*Firebase CLI: Install Firebase CLI
*An Editor (VS Code or Android Studio)

Environment Setup <br>
1. Create the file: In the root of the project, create a file named .env.
2. Add Configuration: Copy the following template and fill in the values (ask the team lead for the specific keys):
API_KEY=your_api_key_here
BASE_URL=https://api.example.com
FIREBASE_MESSAGING_SENDER_ID=123456789
3.Verify Asset Registration: Ensure the .env file is listed in your pubspec.yaml:
assets:
  - .env

Running the App <br>
flutter run 
cd "backend path"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass 
firebase emulators:start
