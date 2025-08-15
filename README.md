# WhisperDate - Production-Ready Dating Review Platform

WhisperDate is a modern, production-ready mobile application for sharing honest dating experiences and building meaningful connections. Built with Flutter and Firebase, it features comprehensive security, analytics, and scalability.

## Features

- **Secure Authentication**: Email/password and Google Sign-In with email verification
- **Review System**: Share dating experiences with ratings and recommendations
- **Real-time Chat**: Secure messaging with image support
- **Location-based Discovery**: Find reviews and users near you
- **Content Moderation**: Automated profanity filtering and manual review system
- **Premium Features**: Subscription-based premium tier
- **Analytics & Monitoring**: Comprehensive tracking and crash reporting
- **Offline Support**: Cache-first architecture for seamless offline experience

## Tech Stack

- **Frontend**: Flutter 3.24.0+
- **Backend**: Firebase (Firestore, Auth, Storage, Functions)
- **Analytics**: Firebase Analytics, Sentry
- **CI/CD**: GitHub Actions
- **State Management**: Provider
- **Testing**: Flutter Test, Mockito

## Getting Started

### Prerequisites

- Flutter SDK 3.24.0 or higher
- Dart SDK 3.6.0 or higher
- Firebase CLI
- Android Studio / Xcode
- Node.js 18+ (for Firebase Functions)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourcompany/whisperdate.git
cd whisperdate
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Set up environment variables**
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. **Configure Firebase**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

5. **Deploy Firebase rules**
```bash
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

6. **Run the app**
```bash
# Development
flutter run

# Staging
flutter run --dart-define=ENVIRONMENT=staging

# Production
flutter run --dart-define=ENVIRONMENT=production --release
```

## Project Structure

```
whisperdate/
├── lib/
│   ├── config/          # Configuration management
│   ├── core/            # Core utilities (validators, error handling, logging)
│   ├── models/          # Data models
│   ├── providers/       # State management
│   ├── screens/         # UI screens
│   ├── services/        # Business logic and API services
│   ├── widgets/         # Reusable UI components
│   └── main.dart        # App entry point
├── test/                # Unit and widget tests
├── android/             # Android-specific code
├── ios/                 # iOS-specific code
├── web/                 # Web-specific code
├── firebase/            # Firebase configuration
│   ├── firestore.rules  # Security rules for Firestore
│   └── storage.rules    # Security rules for Storage
└── .github/workflows/   # CI/CD pipelines
```

## Configuration

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
# Firebase Configuration
FIREBASE_API_KEY_WEB=your_web_api_key
FIREBASE_API_KEY_ANDROID=your_android_api_key
FIREBASE_API_KEY_IOS=your_ios_api_key
FIREBASE_PROJECT_ID=your_project_id

# Features
ENABLE_ANALYTICS=true
ENABLE_CRASHLYTICS=true
ENABLE_CONTENT_MODERATION=true

# API Keys
SENTRY_DSN=your_sentry_dsn
GOOGLE_MAPS_API_KEY=your_maps_key
```

### Firebase Setup

1. **Create a Firebase project**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Create a new project
   - Enable Authentication, Firestore, and Storage

2. **Configure Authentication**
   - Enable Email/Password provider
   - Enable Google Sign-In
   - Set up email verification templates

3. **Deploy security rules**
```bash
firebase deploy --only firestore:rules,storage:rules
```

4. **Set up Cloud Functions** (optional)
```bash
cd functions
npm install
firebase deploy --only functions
```

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widgets/
```

### Integration Tests
```bash
flutter test integration_test/
```

### Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Building for Production

### Android

1. **Configure signing**
```bash
# Generate keystore
keytool -genkey -v -keystore upload-keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000

# Create key.properties
echo "storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks" > android/key.properties
```

2. **Build APK**
```bash
flutter build apk --release --split-per-abi
```

3. **Build App Bundle**
```bash
flutter build appbundle --release
```

### iOS

1. **Configure signing in Xcode**
   - Open `ios/Runner.xcworkspace`
   - Select your team
   - Configure bundle identifier

2. **Build IPA**
```bash
flutter build ios --release
```

3. **Archive for App Store**
```bash
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration Release archive -archivePath $PWD/build/Runner.xcarchive
xcodebuild -exportArchive -archivePath $PWD/build/Runner.xcarchive -exportOptionsPlist ExportOptions.plist -exportPath $PWD/build/ios
```

## Deployment

### CI/CD Pipeline

The project includes GitHub Actions workflows for:
- Code analysis and testing
- Building Android APK/AAB
- Building iOS IPA
- Deploying to Google Play Store and App Store Connect

### Manual Deployment

#### Google Play Store
```bash
# Upload to Google Play Console
fastlane supply --aab build/app/outputs/bundle/release/app-release.aab
```

#### App Store Connect
```bash
# Upload to TestFlight
fastlane pilot upload --ipa build/ios/ipa/Runner.ipa
```

## Security

### Best Practices Implemented

- **Input Validation**: All user inputs are validated and sanitized
- **Authentication**: Secure authentication with email verification
- **Authorization**: Role-based access control with Firebase Security Rules
- **Data Encryption**: All data in transit is encrypted with HTTPS
- **Content Moderation**: Automated and manual content review
- **Rate Limiting**: API rate limiting to prevent abuse
- **Security Headers**: Proper security headers configured
- **Dependency Scanning**: Regular security audits of dependencies

### Security Checklist

- [ ] Firebase Security Rules deployed
- [ ] API keys secured and not committed
- [ ] SSL/TLS certificates valid
- [ ] Input validation enabled
- [ ] Content moderation active
- [ ] Rate limiting configured
- [ ] Error messages don't leak sensitive info
- [ ] Logging doesn't contain PII
- [ ] Dependencies up to date

## Monitoring

### Analytics Events

The app tracks the following events:
- User authentication (sign up, sign in, sign out)
- Review interactions (create, view, like, share)
- Chat activities (messages sent, photos shared)
- Navigation patterns
- Error occurrences
- Performance metrics

### Dashboards

- **Firebase Console**: Real-time analytics and crash reports
- **Sentry**: Error tracking and performance monitoring
- **Google Play Console**: Android vitals and user feedback
- **App Store Connect**: iOS app analytics and reviews

## Performance Optimization

- **Code Splitting**: Lazy loading of features
- **Image Optimization**: WebP format and responsive images
- **Caching Strategy**: Aggressive caching with cache invalidation
- **Database Indexing**: Optimized Firestore queries
- **Bundle Size**: Tree shaking and minification
- **Network Optimization**: Request batching and compression

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is proprietary and confidential. All rights reserved.

## Support

For support, email support@whisperdate.com or create an issue in the repository.

## Roadmap

- [ ] Video reviews
- [ ] AI-powered matching
- [ ] Voice messages
- [ ] Group chats
- [ ] Advanced search filters
- [ ] Social media integration
- [ ] Multi-language support
- [ ] Dark mode improvements

## Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend infrastructure
- All contributors and testers

---

**Note**: This is a production-ready application. Ensure all security measures are in place before deploying to production.