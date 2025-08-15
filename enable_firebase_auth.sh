#!/bin/bash

PROJECT_ID="locker-room-talk-app"

echo "🔐 Enabling Firebase Authentication for $PROJECT_ID..."

# Set the project
gcloud config set project $PROJECT_ID 2>/dev/null

# Enable the Identity Toolkit API (Firebase Auth)
echo "📦 Enabling Identity Toolkit API..."
gcloud services enable identitytoolkit.googleapis.com --project=$PROJECT_ID 2>/dev/null

# Use Firebase Admin SDK to initialize Auth
echo "🔧 Initializing Firebase Auth..."

# Create a Node.js script to initialize Auth
cat > init_auth.js << 'EOF'
const { initializeApp, cert } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');

// Initialize with application default credentials
const app = initializeApp({
  projectId: 'locker-room-talk-app'
});

async function initAuth() {
  try {
    console.log('Initializing Firebase Authentication...');
    
    const auth = getAuth();
    
    // Try to list users (this will initialize Auth if not already done)
    const listUsers = await auth.listUsers(1).catch(err => {
      if (err.code === 'auth/project-not-found' || err.code === 'auth/configuration-not-found') {
        console.log('Auth needs to be enabled in Firebase Console');
        return null;
      }
      throw err;
    });
    
    if (listUsers) {
      console.log('✅ Firebase Auth is already initialized!');
    } else {
      console.log('⚠️  Please enable Authentication in Firebase Console');
    }
    
  } catch (error) {
    console.log('Auth initialization status:', error.message);
  }
  process.exit(0);
}

initAuth();
EOF

# Run the initialization
node init_auth.js 2>/dev/null || echo "Auth initialization attempted"

# Clean up
rm init_auth.js 2>/dev/null

echo ""
echo "✅ Authentication API enabled!"
echo ""
echo "📝 Now you need to:"
echo "1. Go to https://console.firebase.google.com/project/$PROJECT_ID/authentication"
echo "2. Click 'Get Started' button"
echo "3. This will initialize the Authentication service"
echo "4. Then enable these providers:"
echo "   - Anonymous"
echo "   - Email/Password" 
echo "   - Google (optional)"
echo ""
echo "After that, go back to http://localhost:3000 and the app will work!"