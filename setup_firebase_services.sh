#!/bin/bash

PROJECT_ID="locker-room-talk-app"

echo "🔧 Setting up Firebase services for $PROJECT_ID..."

# Set the project
gcloud config set project $PROJECT_ID

# Enable required APIs
echo "📦 Enabling Firebase APIs..."
gcloud services enable \
  firebase.googleapis.com \
  firestore.googleapis.com \
  firebasestorage.googleapis.com \
  identitytoolkit.googleapis.com \
  cloudbuild.googleapis.com \
  firebaserules.googleapis.com \
  --project=$PROJECT_ID

echo "✅ APIs enabled successfully!"

# Create a default Storage bucket
echo "🗄️ Creating Storage bucket..."
gsutil mb -p $PROJECT_ID gs://${PROJECT_ID}.appspot.com 2>/dev/null || echo "Storage bucket already exists"

echo "🎉 Firebase services setup complete!"
echo ""
echo "Next steps:"
echo "1. Go to https://console.firebase.google.com/project/$PROJECT_ID/authentication"
echo "   - Click 'Get Started'"
echo "   - Enable 'Email/Password' provider"
echo "   - Enable 'Google' provider"
echo ""
echo "2. Go to https://console.firebase.google.com/project/$PROJECT_ID/storage"
echo "   - Click 'Get Started' to initialize Storage"
echo ""
echo "The app is ready at http://localhost:3000"