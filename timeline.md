1. Backend (Person A)
•	Set up Firebase project & Cloud Run
•	Implement file upload endpoint (PDFs)
•	Implement ephemeral storage (store temporarily, auto-delete)
•	Connect Gemini LLM API for parsing & legal reasoning
•	Implement scenario simulation API (highlight how clauses affect different personas: student, parent, intern)
•	Return structured AI output (clauses + explanations + risk assessment)
•	Prepare anonymized metrics logging endpoint (Firestore)
•	Handle error cases (invalid PDFs, empty files)
________________________________________
2. Frontend (Flutter, Person B)
•	Create Flutter project skeleton (web + mobile)
•	Implement file upload screen
•	Display processing/loading screen while AI works
•	Display highlighted clauses returned from AI
•	Display scenario simulations / risk explanations
•	Allow user to modify consent choices (toggle/reject specific clauses)
•	Show summary view of final consent decision
•	Connect to metrics logging endpoint (send user interactions / decisions)
________________________________________
3. AI / Document Handling
•	Select sample consent documents / PDFs (5–10 examples)
•	Define clause extraction rules for AI (high-level prompts)
•	Define persona scenarios (student, parent, internship)
•	Test Gemini LLM parsing and refine prompts
•	Simulate risk/consequence explanations
•	Validate AI outputs are plain-language & understandable
________________________________________
4. Visualization / Metrics
•	Create risk/consequence visualization component (simple chart, color-coded highlights)
•	Track user decisions per clause (for demo metrics)
•	Prepare simulated impact metrics for preliminary round
o	% of decisions changed
o	Time-to-understanding (simulate if needed)
o	Confidence score (1–5)
•	Optional: simple dashboard view for demo
________________________________________
5. Miscellaneous / Prep
•	Prepare demo slides for hackathon
•	Prepare test plan for small pilot users (prelims: classmates)
•	Document team workflow in Trello / Notion
•	Prepare presentation notes & talking points
