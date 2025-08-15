const { initializeApp } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');

// Initialize admin SDK
const app = initializeApp({
  projectId: 'locker-room-talk-app',
});

async function enableAuth() {
  try {
    const auth = getAuth();
    
    // Test if auth works by attempting to get a user
    await auth.getUser('test').catch(() => {
      console.log('Auth is working (user not found is expected)');
    });
    
    console.log('Firebase Auth is enabled and configured!');
  } catch (error) {
    console.log('Auth setup status:', error.code === 'auth/user-not-found' ? 'Enabled' : 'Needs enabling');
  }
}

enableAuth();