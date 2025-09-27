Krishi Mitra 🌱

An AI-Powered Agricultural Advisor for the Modern Farmer

Krishi Mitra is a prototype of a multimodal, AI-powered support system designed to provide farmers with instant, expert agricultural advice. Built with a modern tech stack, it allows users to interact with a sophisticated AI through a sleek Android app. Farmers can get answers by typing questions or by simply uploading images of their crops for diagnosis and advice.

✨ Key Features

    Multimodal Input: Get answers by typing a question or by taking a picture of a plant for visual analysis.

    Expert Knowledge Base: The AI's answers are grounded in a curated knowledge base of expert agricultural documents, ensuring advice is accurate and reliable using a Retrieval-Augmented Generation (RAG) pipeline.

    Conversational Context: The AI remembers the flow of your conversation, allowing for natural, intuitive follow-up questions.

    Premium User Experience: A beautiful, high-performance Flutter app featuring a clean, minimalist UI and smooth, satisfying animations for a delightful user experience.

🛠️ Technology Stack

The project is built using a modern, scalable technology stack:
Category	Technology
Frontend	
Backend	
AI & ML	Google Gemini (gemini-1.5-flash-latest, gemini-pro-vision), LangChain
Database	FAISS (Vector Store)
DevOps/Tools	ngrok (for local prototype tunneling)

⚙️ Getting Started: Running the Local Prototype

To get a local copy up and running, follow these simple steps.

Prerequisites

    Flutter SDK: Ensure you have the Flutter SDK installed and configured.

    Python 3.9+: Make sure Python is installed on your system.

    Google AI API Key: You need an active API key from Google AI Studio.

Installation & Setup

    Clone the repository (if applicable)
    Bash

git clone https://github.com/your-username/krishi-mitra.git
cd krishi-mitra

Backend Setup

    Navigate to the backend directory:
    Bash

cd backend

Create and activate a Python virtual environment:
Bash

# For macOS/Linux
python3 -m venv venv
source venv/bin/activate

# For Windows
python -m venv venv
.\venv\Scripts\activate

Install the required dependencies:
Bash

pip install -r requirements.txt

Create a .env file to store your API key. Replace YOUR_SECRET_API_KEY_HERE with your actual key.
Bash

echo "GOOGLE_API_KEY='YOUR_SECRET_API_KEY_HERE'" > .env

Run the backend server:
Bash

    uvicorn main:app --reload

The backend will now be running on http://127.0.0.1:8000.

Expose Backend with ngrok

    In a new terminal window, use ngrok to create a public URL for your local backend server:
    Bash

    ngrok http 8000

    Copy the HTTPS forwarding URL provided by ngrok (e.g., https://random-string.ngrok-free.app).

Frontend Setup

    Navigate to the frontend project folder:
    Bash

cd ../frontend

Open the lib/main.dart file in your editor.

Find the apiUrl constant and replace the placeholder URL with your ngrok HTTPS URL.
Dart

// lib/main.dart
const String apiUrl = 'YOUR_NGROK_HTTPS_URL_HERE';

Run the Flutter app on an emulator or a connected physical device:
Bash

        flutter run

You should now have the Krishi Mitra app running and connected to your local backend!

📄 License

This project is distributed under the MIT License. See LICENSE file for more information.
