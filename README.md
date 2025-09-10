Krishi Mitra 🌱 - AI Agricultural Advisor

Krishi Mitra is a prototype of a multimodal, AI-powered support system designed to provide farmers with instant, expert agricultural advice. Users can interact with the AI through a sleek, modern Android app, asking questions via text and by uploading images of their crops for diagnosis.
✨ Key Features

    Multimodal Input: Get answers by typing a question or by simply taking a picture of a plant.

    Expert Knowledge Base: The AI's answers are grounded in a curated knowledge base of expert agricultural documents, ensuring advice is accurate and reliable (Retrieval-Augmented Generation).

    Conversational Context: The AI remembers the context of your conversation, allowing for natural follow-up questions.

    Premium User Experience: A beautiful, high-performance Flutter app with a clean, minimalist UI and smooth, satisfying animations.

🚀 Live Demo

(Recommendation: Create a short screen recording of your app in action and upload it as a GIF. It's the best way to showcase your work! You can use free tools like ScreenToGif or Kap.)
🛠️ Technology Stack

    Frontend: Flutter & Dart

    Backend: Python & FastAPI

    AI Models: Google Gemini (gemini-1.5-flash-latest, gemini-pro-vision)

    RAG Pipeline: LangChain

    Vector Database: FAISS (for local similarity search)

    Local Connectivity: ngrok (for the prototype demo)

⚙️ How to Run the Local Prototype

Prerequisites:

    Flutter SDK

    Python 3.9+

    An active Google AI API Key

1. Backend Setup:

# Navigate to the backend folder
cd backend

# Create and activate a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: .\venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create a .env file and add your API key
echo "GOOGLE_API_KEY='YOUR_SECRET_API_KEY_HERE'" > .env

# Run the backend server
uvicorn main:app --reload

2. Frontend Setup:

# (In a new terminal) Run ngrok to get a public URL for your backend
ngrok http 8000

# Copy the ngrok HTTPS URL

# Navigate to the frontend folder
cd ../frontend

# Update the `apiUrl` constant in lib/main.dart with your ngrok URL

# Run the Flutter app on an emulator or a connected device
flutter run

📄 License

This project is licensed under the MIT License.