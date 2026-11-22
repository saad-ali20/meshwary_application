# إعداد خرائط جوجل في تطبيق مشواري (Meshwary Google Maps Setup)

هذا الدليل يوضح خطوات إعداد مفاتيح **Google Maps SDK** لكل من نظامي **Android** و **iOS** محلياً دون رفع المفاتيح لمستودع Git.

---

## 1. تفعيل واجهات البرمجة (Google Cloud Console)

1. ادخل إلى [Google Cloud Console](https://console.cloud.google.com/).
2. اختر مشروع تطبيق **مشواري (Meshwary)** أو أنشئ مشروعاً جديداً.
3. توجه إلى **APIs & Services** > **Library**.
4. فعّل كل من:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**

---

## 2. إعداد مفتاح Android

### أ. تقييد المفتاح (Key Restrictions)
في شاشة **Credentials** عند إنشاء أو تعديل المفتاح:
1. اختر **Set an application restriction** -> **Android apps**.
2. اضغط **Add an item**:
   - **Package name**: `com.example.meshwary_app`
   - **SHA-1 certificate fingerprint**:
     - للحصول على بصمة المفتاح التجريبي (Debug SHA-1)، نفذ الأمر:
       ```bash
       keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
       ```
     - انسخ بصمة `SHA1` (مثال: `AA:BB:CC:...`).
3. في قسم **API restrictions**، اختر **Restrict key** وحدد **Maps SDK for Android**.

### ب. وضع المفتاح في المشروع
افتح الملف التالي (أو انسخه من `android/local.properties.example`):
```text
android/local.properties
```
وأضف السطر التالي:
```properties
maps.apiKey=AIzaSy_YOUR_ACTUAL_ANDROID_KEY_HERE
```
*ملاحظة: ملف `local.properties` مستثنى تلقائياً من Git عبر `.gitignore`.*

---

## 3. إعداد مفتاح iOS

### أ. تقييد المفتاح (Key Restrictions)
في شاشة **Credentials**:
1. اختر **Set an application restriction** -> **iOS apps**.
2. اضغط **Add an item**:
   - **Bundle identifier**: `com.example.meshwaryApp`
3. في قسم **API restrictions**، حدد **Maps SDK for iOS**.

### ب. وضع المفتاح في المشروع
انسخ الملف النموذجي `ios/Flutter/Keys.xcconfig.example` إلى:
```text
ios/Flutter/Keys.xcconfig
```
وضع فيه المفتاح كالتالي:
```xcconfig
MAPS_API_KEY=AIzaSy_YOUR_ACTUAL_IOS_KEY_HERE
```
*ملاحظة: ملف `ios/Flutter/Keys.xcconfig` مستثنى تلقائياً من Git عبر `.gitignore`.*

---

## 4. تنبيه هام: إعادة البناء الأصلي (Native Rebuild Required)

قراءة مفاتيح الخرائط تتم أثناء عملية البناء الأصلي (Native compilation في Gradle و Xcode).
عند إضافة المفتاح أو تعديله، **لن يسري التغيير عبر Hot Reload أو Hot Restart**.

يجب تنفيذ أمر إعادة البناء:
```bash
flutter clean
flutter run
```
أو على محاكي/جهاز محدد:
```bash
flutter run -d ios
flutter run -d android
```

---

## 5. حالة التطوير عند عدم توفر المفاتيح (Keys Unavailable)
إذا لم تكن المفاتيح متوفرة بعد أثناء التطوير، سيظل التطبيق يعمل بشكل كامل وبدون انهيار (Graceful fallback):
- يتم تهيئة واجهات التطبيق ومحرك الحالة (HomeCubit).
- تظهر السكوترات الستة في سوهاج، وبيانات تفاصيل السكوتر في الشيت السفلي.
- عند إضافة المفاتيح وإعادة البناء، سيتم تحميل بلاطات الخريطة الداكنة فوراً.
