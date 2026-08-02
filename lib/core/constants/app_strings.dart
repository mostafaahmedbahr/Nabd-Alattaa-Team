class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'نبض العطاء';
  static const String appTagline = 'مقياس أداء الفرق والإدارات';

  // Auth
  static const String login = 'تسجيل الدخول';
  static const String logout = 'تسجيل الخروج';
  static const String email = 'البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String resetPassword = 'إعادة تعيين كلمة المرور';
  static const String loginError = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
  static const String resetPasswordSent = 'تم إرسال رابط إعادة تعيين كلمة المرور';
  static const String emailRequired = 'البريد الإلكتروني مطلوب';
  static const String passwordRequired = 'كلمة المرور مطلوبة';
  static const String passwordTooShort = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  // Navigation
  static const String home = 'الرئيسية';
  static const String tasks = 'المهام';
  static const String announcements = 'الإعلانات';
  static const String complaints = 'الشكاوى والاقتراحات';
  static const String library = 'المكتبة';
  static const String ideas = 'صندوق الأفكار';
  static const String reports = 'البلاغات';
  static const String notifications = 'التنبيهات';
  static const String chat = 'الشات';
  static const String goodDeeds = 'عملت خير إيه النهارده؟';
  static const String meals = 'طلبات الطعام';
  static const String profile = 'الملف الشخصي';
  static const String admin = 'الإدارة';

  // Tasks
  static const String createTask = 'إنشاء مهمة';
  static const String taskTitle = 'عنوان المهمة';
  static const String taskDescription = 'وصف المهمة';
  static const String assignee = 'المسؤول';
  static const String priority = 'الأولوية';
  static const String high = 'عالية';
  static const String medium = 'متوسطة';
  static const String low = 'منخفضة';
  static const String dueDate = 'موعد التسليم';
  static const String notStarted = 'لم تبدأ';
  static const String inProgress = 'جاري التنفيذ';
  static const String inReview = 'قيد المراجعة';
  static const String completed = 'مكتملة';
  static const String late = 'متأخرة';
  static const String taskCreated = 'تم إنشاء المهمة بنجاح';
  static const String taskUpdated = 'تم تحديث المهمة بنجاح';
  static const String taskDeleted = 'تم حذف المهمة بنجاح';

  // Announcements
  static const String createAnnouncement = 'إنشاء إعلان';
  static const String announcementTitle = 'عنوان الإعلان';
  static const String announcementContent = 'محتوى الإعلان';
  static const String announcementCreated = 'تم نشر الإعلان بنجاح';

  // Complaints
  static const String submitComplaint = 'إرسال شكوى';
  static const String complaintTitle = 'عنوان الشكوى';
  static const String complaintContent = 'تفاصيل الشكوى';
  static const String anonymous = 'مجهول الهوية';
  static const String complaintSubmitted = 'تم إرسال الشكوى بنجاح';

  // Ideas
  static const String submitIdea = 'تقديم فكرة';
  static const String ideaTitle = 'عنوان الفكرة';
  static const String ideaContent = 'تفاصيل الفكرة';
  static const String ideaSubmitted = 'تم تقديم الفكرة بنجاح';
  static const String ideaAccepted = 'مقبولة';
  static const String ideaRejected = 'مرفوضة';
  static const String ideaImplemented = 'تم التنفيذ';

  // Reports (بلاغات)
  static const String createReport = 'إنشاء بلاغ';
  static const String reportTitle = 'عنوان البلاغ';
  static const String reportContent = 'تفاصيل البلاغ';
  static const String reportType = 'نوع البلاغ';
  static const String reportCreated = 'تم إنشاء البلاغ بنجاح';

  // Chat
  static const String typeMessage = 'اكتب رسالة...';
  static const String sendMessage = 'إرسال';
  static const String noMessages = 'لا توجد رسائل';

  // Good Deeds
  static const String shareGoodDeed = 'شارك عمل خير';
  static const String goodDeedContent = 'ماذا فعلت خير اليوم؟';
  static const String goodDeedShared = 'تم مشاركة عمل الخير بنجاح';
  static const String like = 'أعجبني';
  static const String pray = 'دعاء';

  // Meals
  static const String breakfast = 'فطار';
  static const String lunch = 'غداء';
  static const String orderNow = 'اطلب الآن';
  static const String orderSummary = 'ملخص الطلبات';
  static const String total = 'الإجمالي';
  static const String paid = 'تم الدفع';
  static const String notPaid = 'لم يتم الدفع';


  // Profile
  static const String editProfile = 'تعديل الملف الشخصي';
  static const String name = 'الاسم';
  static const String phone = 'رقم الهاتف';
  static const String department = 'القسم';
  static const String position = 'الوظيفة';
  static const String profileUpdated = 'تم تحديث الملف الشخصي بنجاح';

  // Admin
  static const String dashboard = 'لوحة التحكم';
  static const String manageEmployees = 'إدارة الموظفين';
  static const String manageDepartments = 'الأقسام';
  static const String manageRoles = 'الصلاحيات';
  static const String statistics = 'الإحصائيات';
  static const String reportsTitle = 'التقارير';

  // Common
  static const String loading = 'جاري التحميل...';
  static const String error = 'حدث خطأ';
  static const String retry = 'إعادة المحاولة';
  static const String cancel = 'إلغاء';
  static const String save = 'حفظ';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';
  static const String add = 'إضافة';
  static const String confirm = 'تأكيد';
  static const String yes = 'نعم';
  static const String no = 'لا';
  static const String noData = 'لا توجد بيانات';
  static const String search = 'بحث';
  static const String filter = 'تصفية';
  static const String sort = 'ترتيب';
  static const String from = 'من';
  static const String to = 'إلى';
  static const String date = 'التاريخ';
  static const String time = 'الوقت';
  static const String status = 'الحالة';
  static const String description = 'الوصف';
  static const String title = 'العنوان';
  static const String content = 'المحتوى';
  static const String category = 'الفئة';
  static const String all = 'الكل';
  static const String send = 'إرسال';
  static const String reply = 'رد';
  static const String view = 'عرض';
  static const String close = 'إغلاق';
  static const String open = 'فتح';
  static const String pending = 'قيد الانتظار';
  static const String approved = 'تمت الموافقة';
  static const String rejected = 'مرفوض';
  static const String active = 'نشط';
  static const String inactive = 'غير نشط';



  /// storage
  static const String onboardingComplete = 'onboarding_complete';
}
