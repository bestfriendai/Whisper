// Initialize test data in Firestore
// Run this after setting up Authentication in Firebase Console

const admin = require('firebase-admin');

// Initialize admin SDK
if (!admin.apps.length) {
  admin.initializeApp({
    projectId: 'locker-room-talk-app',
  });
}

const db = admin.firestore();

async function initTestData() {
  console.log('🚀 Initializing test data for Locker Room Talk...');
  
  try {
    // Create test users collection
    const usersRef = db.collection('users');
    
    // Add test users
    const testUsers = [
      {
        uid: 'test_user_1',
        email: 'john@example.com',
        displayName: 'John Doe',
        username: 'johndoe',
        bio: 'Love coffee dates and hiking!',
        location: { city: 'New York', state: 'NY', country: 'USA' },
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      {
        uid: 'test_user_2',
        email: 'jane@example.com',
        displayName: 'Jane Smith',
        username: 'janesmith',
        bio: 'Foodie and adventure seeker',
        location: { city: 'Los Angeles', state: 'CA', country: 'USA' },
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }
    ];
    
    for (const user of testUsers) {
      await usersRef.doc(user.uid).set(user);
      console.log(`✅ Created user: ${user.displayName}`);
    }
    
    // Create test reviews
    const reviewsRef = db.collection('reviews');
    
    const testReviews = [
      {
        authorId: 'test_user_1',
        subjectName: 'Emma Wilson',
        subjectAge: 28,
        subjectGender: 'female',
        category: 'coffee',
        dateDuration: 'twoToThreeHours',
        dateYear: 2024,
        relationshipType: 'casual',
        title: 'Amazing Coffee Date at Central Perk',
        content: 'Had a wonderful time! Great conversation, amazing coffee, and the atmosphere was perfect. Would definitely recommend this spot for a first date.',
        rating: 5,
        wouldRecommend: true,
        location: { city: 'New York', state: 'NY', country: 'USA' },
        venue: 'Central Perk Cafe',
        tags: ['coffee', 'firstdate', 'romantic'],
        imageUrls: [],
        isAnonymous: false,
        stats: {
          views: 142,
          likes: 23,
          comments: 5,
          shares: 2,
          helpful: 18,
          notHelpful: 1
        },
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      {
        authorId: 'test_user_2',
        subjectName: 'Michael Chen',
        subjectAge: 32,
        subjectGender: 'male',
        category: 'dinner',
        dateDuration: 'twoToThreeHours',
        dateYear: 2024,
        relationshipType: 'serious',
        title: 'Romantic Dinner at The Ivy',
        content: 'Absolutely perfect evening! The restaurant had amazing ambiance, food was incredible, and my date was charming. Highly recommend for special occasions.',
        rating: 5,
        wouldRecommend: true,
        location: { city: 'Los Angeles', state: 'CA', country: 'USA' },
        venue: 'The Ivy Restaurant',
        tags: ['dinner', 'romantic', 'upscale'],
        imageUrls: [],
        isAnonymous: false,
        stats: {
          views: 287,
          likes: 45,
          comments: 12,
          shares: 8,
          helpful: 38,
          notHelpful: 2
        },
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      {
        authorId: 'test_user_1',
        subjectName: 'Anonymous',
        subjectAge: 26,
        subjectGender: 'other',
        category: 'activity',
        dateDuration: 'halfDay',
        dateYear: 2024,
        relationshipType: 'casual',
        title: 'Fun Beach Day Adventure',
        content: 'Spent the day at Santa Monica beach. Great weather, fun activities, and lots of laughs. The sunset was absolutely beautiful!',
        rating: 4,
        wouldRecommend: true,
        location: { city: 'Santa Monica', state: 'CA', country: 'USA' },
        venue: 'Santa Monica Beach',
        tags: ['beach', 'outdoor', 'adventure'],
        imageUrls: [],
        isAnonymous: true,
        stats: {
          views: 98,
          likes: 15,
          comments: 3,
          shares: 1,
          helpful: 12,
          notHelpful: 0
        },
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }
    ];
    
    for (const review of testReviews) {
      const docRef = await reviewsRef.add(review);
      console.log(`✅ Created review: ${review.title} (ID: ${docRef.id})`);
    }
    
    console.log('\n🎉 Test data initialization complete!');
    console.log('📱 Your app is ready at http://localhost:3000');
    console.log('\n⚠️  Remember to enable Authentication providers in Firebase Console:');
    console.log('   https://console.firebase.google.com/project/locker-room-talk-app/authentication');
    
  } catch (error) {
    console.error('❌ Error initializing test data:', error);
  }
  
  process.exit(0);
}

initTestData();