// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مشواري';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get save => 'حفظ';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get errorGeneric => 'حدث خطأ، يرجى المحاولة مجدداً.';

  @override
  String get errorNetwork =>
      'تعذّر الاتصال بالإنترنت. تحقق من الشبكة وأعد المحاولة.';

  @override
  String get errorTimeout => 'انتهت مهلة الطلب. يرجى المحاولة مجدداً.';

  @override
  String get errorUnauthorized => 'انتهت جلستك. يرجى تسجيل الدخول مجدداً.';

  @override
  String get designPreviewTitle => 'معاينة نظام التصميم';

  @override
  String get designPreviewSubtitle => 'مشواري — الهوية البصرية';
}
