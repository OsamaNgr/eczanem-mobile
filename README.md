# 🏥 Eczanem - Pharmacy Management Mobile App

A comprehensive Flutter-based pharmacy management application with AI-powered medical assistant. 

## ✨ Features

- 🛒 **Product Management** - Browse and manage pharmacy inventory
- 🤖 **AI Medical Assistant** - Powered by Google Gemini AI
- 👤 **User Authentication** - Secure login and registration
- 🏪 **Pharmacy Operations** - Complete pharmacy workflow management
- 📊 **Dashboard Analytics** - Real-time insights and reports
- 🔍 **Smart Search** - Find medicines quickly
- 🛍️ **Shopping Cart** - Seamless ordering experience

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Laravel (PHP)
- **Database:** MySQL
- **AI:** Google Gemini API
- **State Management:** Provider/Bloc
- **Architecture:** Clean Architecture

## 📋 Prerequisites

- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / VS Code
- XAMPP (for local backend)
- Git

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/OsamaNgr/eczanem-mobile.git
cd eczanem-mobile
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment

Create a `.env` file in the project root:

```env
API_BASE_URL=http://10.0.2.2/Eczanem-Backend
GEMINI_API_KEY=your-gemini-api-key-here
```

**Get your Gemini API key:** https://aistudio.google.com/app/apikey

### 4. Setup Backend

1. Clone backend repository:
   ```bash
   git clone https://github.com/OsamaNgr/eczanem-backend.git
   ```

2. Move to XAMPP htdocs:
   ```
   C:\xampp\htdocs\Eczanem-Backend\
   ```

3. Start XAMPP (Apache + MySQL)

4. Create database `eczanem` in phpMyAdmin

5. Run migrations from backend

### 5. Run the App

```bash
flutter run
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- 🚧 Web (Coming soon)

## 🏗️ Project Structure

```
lib/
├── core/           # Core utilities and constants
├── features/       # Feature modules
│   ├── auth/      # Authentication
│   ├── home/      # Home dashboard
│   ├── products/  # Product management
│   └── ai/        # AI assistant
├── shared/        # Shared widgets and components
└── main.dart      # App entry point
```

## 🔗 Related Repositories

- **Backend API:** [eczanem-backend](https://github.com/OsamaNgr/eczanem-backend)

## 🔐 Security

- Environment variables for sensitive data
- Secure API communication
- Token-based authentication
- Input validation and sanitization

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Developer:** OsamaNgr
- **Project:** Eczanem Pharmacy Management System

## 📞 Support

For support, email sppml5@hotmail.com or open an issue in the repository. 

---

**Made with ❤️ for better pharmacy management**