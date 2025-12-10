import 'package:get/get.dart';

class LocaleController extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en": {
          // Navigation
          "home": "Home",
          "search": "Search",
          "cart": "Cart",
          "orders": "Orders",
          "favourite": "Favourites",
          "profile": "Profile",
          "close": "Close",

          // AI Assistant
          "aiAssistant": "AI Assistant",
          "aiAssistantWelcome": "Welcome to AI Assistant",
          "aiAssistantDescription": "Ask me about any medicine or take a photo to identify it",
          "scanMedicine": "Scan Medicine",
          "scanPrescription": "Scan Prescription",
          "typeMessage": "Type a message...",
          "aiThinking": "Thinking...",
          "selectImageSource": "Select Image Source",
          "camera": "Camera",
          "gallery": "Gallery",
          "failedToPickImage": "Failed to pick image",
          "qrScannerComingSoon": "QR Scanner coming soon",
          "justNow": "Just now",
          "minutesAgo": " min ago",
          "hoursAgo": " hrs ago",

          // AI Suggestions
          "whatIsPanadol": "What is Panadol?",
          "howToUseMedicine": "How do I use this medicine?",
          "checkSideEffects": "What are the side effects?",

          // Auth - Login
          "welcomeMessage": "Welcome Back",
          "enterCredentials": "Enter your credentials to continue",
          "userNumber": "Email or Phone Number",
          "password": "Password",
          "signIn":  "Sign In",
          "notAMember": "Not a member?  ",
          "register": "Register",
          "forgotPassword":  "Forgot Password? ",
          "forgotPasswordComingSoon":  "Forgot password feature coming soon",
          "enterValidEmailOrPhone": "Please enter a valid email or phone number",

          // Auth - Register
          "letsCreateAnAccount": "Let's Create An Account",
          "email": "Email Address",
          "userName": "Username",
          "phoneNumberOptional": "Phone Number (Optional - 05XXXXXXXXX)",
          "confirmPassword": "Confirm Password",
          "signUp":  "Sign Up",
          "alreadyHaveAnAccount": "Already have an account?  ",

          // Social Login - NEW
          "or": "or",
          "continueWithGoogle": "Continue with Google",
          "continueWithApple": "Continue with Apple",
          "continueWithFacebook": "Continue with Facebook",
          "dontHaveAccount": "Don't have an account?  ",
          "orContinueWith": "Other Sign-In Options",
          "signInWithGoogle": "Continue with Google",
          "signInWithFacebook": "Continue with Facebook",
          "signInWithApple": "Continue with Apple",

          // Validation Messages
          "fieldIsRequired": "This field is required",
          "enterValidEmail": "Please enter a valid email address",
          "usernameRequired": "Username is required",
          "usernameTooShort": "Username must be at least 3 characters",
          "usernameTooLong": "Username cannot exceed 20 characters",
          "phoneInvalidFormat": "Phone number must start with 05",
          "phoneInvalidLength":  "Phone number must be exactly 11 digits",
          "enterValidPhoneNumber": "Please enter a valid phone number",
          "passwordRequired": "Password is required",
          "passwordTooShort":  "Password must be at least 8 characters",
          "passwordsDoNotMatch": "Passwords do not match",

          // Success Messages
          "signedInSuccess":  "Signed in successfully! ",
          "registerSuccess": "Registered successfully! ",
          "logedOutSuccess": "Logged out successfully! ",

          // Profile Page - NEW
          "guestMode":  "Guest Mode",
          "signInToAccessProfile": "Sign in to access your profile",
          "userInformation": "User Information",
          "addresses": "Addresses",
          "savedCards": "Saved Cards",
          "notifications": "Notifications",
          "language": "Language",
          "selectLanguage": "Select Language",
          "english": "English",
          "turkish": "Turkish",
          "statistics": "Statistics",
          "logout": "Logout",
          "darkMode": "Dark Mode",
          "lightMode":  "Light Mode",
          "theme": "Theme",

          // Home Page
          "searchFor": "Search",
          "categories": "Categories",
          "mostPopular": "Most Popular",
          "recentlyAdd": "Recently Added",
          "recentlyAdded":  "Recently Added",
          "all": "All",
          "All": "All",

          // Search Filter - NEW
          "searchBy": "Search By",
          "chooseSearchMethod": "Choose how to search for products",
          "productName": "Product Name",
          "scientificName": "Scientific Name",
          "description": "Description",
          "name": "Product Name",

          // Product Details
          "brand": "Brand",
          "inStock": "In Stock",
          "category": "Category",
          "expiration": "Expiration Date",
          "addToCart": "Add to Cart",
          "addedToCart": "Added to cart successfully!  ",
          "addedToCartSuccessfully": "Added to cart successfully! ",
          "failedToAddToTheCart": "Failed to add to cart",
          "unavailable": "Unavailable",
          "quantity": "Quantity",
          "enterQuantity": "Enter Quantity",
          "add":  "Add",

          // Search Page - NEW
          "noProductsFound": "No Products Found",
          "tryDifferentSearch": "Try a different search term",

          // Orders Page - NEW
          "noOrdersYet": "No Orders Yet",
          "orderHistoryDescription": "Your order history will appear here once you make your first purchase",
          "startShopping": "Start Shopping",

          // Currency
          "SP": "TL",

          // Cart
          "emptyCart": "Your cart is empty",
          "total": "Total",
          "checkout": "Checkout",
          "purchaseSuccess":  "Purchase completed successfully!",

          // General
          "somethingWrongHappened": "Something went wrong",
          "networkError": "Network error. Please check your connection",
          "tryAgain": "Try Again",
          "cancel": "Cancel",
          "confirm": "Confirm",
        },
        
        // TURKISH TRANSLATIONS
        "tr": {
          // Navigation
          "home": "Ana Sayfa",
          "search": "Ara",
          "cart": "Sepet",
          "orders":  "Siparişler",
          "favourite": "Favoriler",
          "profile": "Profil",
          "close":  "Kapat",

          // AI Assistant
          "aiAssistant": "Yapay Zeka Asistanı",
          "aiAssistantWelcome": "Yapay Zeka Asistanına Hoş Geldiniz",
          "aiAssistantDescription": "Herhangi bir ilaç hakkında soru sorun veya tanımlamak için fotoğraf çekin",
          "scanMedicine":  "İlaç Tara",
          "scanPrescription":  "Reçete Tara",
          "typeMessage":  "Bir mesaj yazın...",
          "aiThinking": "Düşünüyor...",
          "selectImageSource": "Resim Kaynağını Seçin",
          "camera": "Kamera",
          "gallery": "Galeri",
          "failedToPickImage": "Resim seçilemedi",
          "qrScannerComingSoon": "QR Tarayıcı yakında geliyor",
          "justNow": "Şimdi",
          "minutesAgo":  " dakika önce",
          "hoursAgo": " saat önce",

          // AI Suggestions
          "whatIsPanadol": "Panadol nedir?",
          "howToUseMedicine":  "Bu ilacı nasıl kullanırım?",
          "checkSideEffects": "Yan etkileri nelerdir?  ",

          // Auth - Login
          "welcomeMessage": "Tekrar Hoş Geldiniz",
          "enterCredentials":  "Devam etmek için bilgilerinizi girin",
          "userNumber": "E-posta veya Telefon Numarası",
          "password": "Şifre",
          "signIn": "Giriş Yap",
          "notAMember": "Üye değil misiniz?   ",
          "register": "Kayıt Ol",
          "forgotPassword": "Şifremi Unuttum",
          "forgotPasswordComingSoon": "Şifremi unuttum özelliği yakında geliyor",
          "enterValidEmailOrPhone":  "Lütfen geçerli bir e-posta veya telefon numarası girin",

          // Auth - Register
          "letsCreateAnAccount": "Hesap Oluşturalım",
          "email": "E-posta Adresi",
          "userName": "Kullanıcı Adı",
          "phoneNumberOptional": "Telefon Numarası (İsteğe Bağlı - 05XXXXXXXXX)",
          "confirmPassword": "Şifreyi Onayla",
          "signUp": "Kayıt Ol",
          "alreadyHaveAnAccount": "Zaten bir hesabınız var mı?  ",

          // Social Login - NEW
          "or":  "veya",
          "continueWithGoogle": "Google ile devam et",
          "continueWithApple": "Apple ile devam et",
          "continueWithFacebook": "Facebook ile devam et",
          "dontHaveAccount": "Hesabınız yok mu?  ",
          "orContinueWith": "Diğer Giriş Seçenekleri",
          "signInWithGoogle": "Google ile devam et",
          "signInWithFacebook": "Facebook ile devam et",
          "signInWithApple": "Apple ile devam et",

          // Validation Messages
          "fieldIsRequired": "Bu alan zorunludur",
          "enterValidEmail": "Lütfen geçerli bir e-posta adresi girin",
          "usernameRequired": "Kullanıcı adı gereklidir",
          "usernameTooShort": "Kullanıcı adı en az 3 karakter olmalıdır",
          "usernameTooLong": "Kullanıcı adı 20 karakteri geçemez",
          "phoneInvalidFormat": "Telefon numarası 05 ile başlamalıdır",
          "phoneInvalidLength": "Telefon numarası tam olarak 11 haneli olmalıdır",
          "enterValidPhoneNumber":  "Lütfen geçerli bir telefon numarası girin",
          "passwordRequired":  "Şifre gereklidir",
          "passwordTooShort": "Şifre en az 8 karakter olmalıdır",
          "passwordsDoNotMatch": "Şifreler eşleşmiyor",

          // Success Messages
          "signedInSuccess":  "Başarıyla giriş yapıldı! ",
          "registerSuccess": "Başarıyla kayıt olundu!",
          "logedOutSuccess": "Başarıyla çıkış yapıldı!",

          // Profile Page - NEW
          "guestMode": "Misafir Modu",
          "signInToAccessProfile": "Profilinize erişmek için giriş yapın",
          "userInformation": "Kullanıcı Bilgilerim",
          "addresses": "Adreslerim",
          "savedCards":  "Kayıtlı Kartlarım",
          "notifications": "Bildirimler",
          "language": "Dil",
          "selectLanguage": "Dil Seçin",
          "english": "İngilizce",
          "turkish": "Türkçe",
          "statistics": "İstatistikler",
          "logout": "Çıkış Yap",
          "darkMode": "Karanlık Mod",
          "lightMode": "Aydınlık Mod",
          "theme": "Tema",

          // Home Page
          "searchFor": "Ara",
          "categories": "Kategoriler",
          "mostPopular": "En Popüler",
          "recentlyAdd": "Yeni Eklenenler",
          "recentlyAdded": "Yeni Eklenenler",
          "all": "Tümü",
          "All": "Tümü",

          // Search Filter - NEW
          "searchBy": "Arama Kriteri",
          "chooseSearchMethod": "Ürün arama yöntemini seçin",
          "productName": "Ürün Adı",
          "scientificName": "Bilimsel Adı",
          "description": "Açıklama",
          "name": "Ürün Adı",

          // Product Details
          "brand": "Marka",
          "inStock": "Stokta",
          "category": "Kategori",
          "expiration":  "Son Kullanma Tarihi",
          "addToCart": "Sepete Ekle",
          "addedToCart": "Sepete başarıyla eklendi!",
          "addedToCartSuccessfully": "Sepete başarıyla eklendi!",
          "failedToAddToTheCart": "Sepete eklenemedi",
          "unavailable": "Mevcut Değil",
          "quantity":  "Miktar",
          "enterQuantity": "Miktar Girin",
          "add":  "Ekle",

          // Search Page - NEW
          "noProductsFound": "Ürün Bulunamadı",
          "tryDifferentSearch": "Farklı bir arama terimi deneyin",

          // Orders Page - NEW
          "noOrdersYet": "Henüz Sipariş Yok",
          "orderHistoryDescription": "İlk satın alma işleminizi yaptığınızda sipariş geçmişiniz burada görünecektir",
          "startShopping": "Alışverişe Başla",

          // Currency
          "SP": "TL",

          // Cart
          "emptyCart": "Sepetiniz boş",
          "total": "Toplam",
          "checkout": "Ödeme",
          "purchaseSuccess": "Satın alma başarıyla tamamlandı! ",

          // General
          "somethingWrongHappened": "Bir şeyler yanlış gitti",
          "networkError":  "Ağ hatası.  Lütfen bağlantınızı kontrol edin",
          "tryAgain": "Tekrar Dene",
          "cancel": "İptal",
          "confirm":  "Onayla",
        },
      };
}