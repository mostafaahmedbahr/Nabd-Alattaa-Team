class FirestoreConstants {
  FirestoreConstants._();

  // Collections
  static const String users = 'users';
  static const String tasks = 'tasks';
  static const String taskComments = 'task_comments';
  static const String announcements = 'announcements';
  static const String complaints = 'complaints';
  static const String complaintComments = 'complaint_comments';
  static const String ideas = 'ideas';
  static const String reports = 'reports';
  static const String reportComments = 'report_comments';
  static const String messages = 'messages';
  static const String chatRooms = 'chat_rooms';
  static const String goodDeeds = 'good_deeds';
  static const String goodDeedReactions = 'good_deed_reactions';
  static const String meals = 'meals';
  static const String mealOrders = 'meal_orders';
  static const String mealItems = 'meal_items';
  static const String notifications = 'notifications';
  static const String departments = 'departments';
  static const String settings = 'settings';
  static const String points = 'points';
  static const String activities = 'activities';

  // User Fields
  static const String userId = 'user_id';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userPhone = 'user_phone';
  static const String userRole = 'user_role';
  static const String userDepartment = 'user_department';
  static const String userPosition = 'user_position';
  static const String userIsActive = 'is_active';
  static const String isBreakFast = 'is_breakfast';
  static const String userFcmToken = 'fcm_token';
  static const String userCreatedAt = 'created_at';
  static const String userPoints = 'points';

  // Task Fields
  static const String taskTitle = 'title';
  static const String taskDescription = 'description';
  static const String taskAssigneeId = 'assignee_id';
  static const String taskAssigneeName = 'assignee_name';
  static const String taskCreatorId = 'creator_id';
  static const String taskCreatorName = 'creator_name';
  static const String taskPriority = 'priority';
  static const String taskStatus = 'status';
  static const String taskDueDate = 'due_date';
  static const String taskCreatedAt = 'created_at';
  static const String taskUpdatedAt = 'updated_at';
  static const String taskCompletionPercentage = 'completion_percentage';

  // Task Subtask Fields
  static const String taskSubtasks = 'subtasks';
  static const String taskSubtaskId = 'subtask_id';
  static const String taskSubtaskTitle = 'title';
  static const String taskSubtaskIsCompleted = 'is_completed';
  static const String taskSubtaskCompletedAt = 'completed_at';
  static const String taskSubtaskCompletedBy = 'completed_by';
  static const String taskSubtaskOrder = 'order';

  // Task Forwarding Fields
  static const String taskIsForwarded = 'is_forwarded';
  static const String taskOriginalTaskId = 'original_task_id';
  static const String taskParentTaskId = 'parent_task_id';
  static const String taskForwardedFromUserId = 'forwarded_from_user_id';
  static const String taskForwardedFromUserName = 'forwarded_from_user_name';
  static const String taskForwardedToUserId = 'forwarded_to_user_id';
  static const String taskForwardedAt = 'forwarded_at';
  static const String taskForwardNote = 'forward_note';

  // Announcement Fields
  static const String announcementTitle = 'title';
  static const String announcementContent = 'content';
  static const String announcementCreatorId = 'creator_id';
  static const String announcementCreatorName = 'creator_name';
  static const String announcementType = 'type';
  static const String announcementIsPinned = 'is_pinned';
  static const String announcementCreatedAt = 'created_at';

  // Complaint Fields
  static const String complaintTitle = 'title';
  static const String complaintContent = 'content';
  static const String complaintType = 'type';
  static const String complaintIsAnonymous = 'is_anonymous';
  static const String complaintStatus = 'status';
  static const String complaintCreatorId = 'creator_id';
  static const String complaintCreatorName = 'creator_name';
  static const String complaintAssignedTo = 'assigned_to';
  static const String complaintCreatedAt = 'created_at';
  static const String complaintUpdatedAt = 'updated_at';

  // Idea Fields
  static const String ideaTitle = 'title';
  static const String ideaContent = 'content';
  static const String ideaStatus = 'status';
  static const String ideaCreatorId = 'creator_id';
  static const String ideaCreatorName = 'creator_name';
  static const String ideaRating = 'rating';
  static const String ideaCreatedAt = 'created_at';
  static const String ideaUpdatedAt = 'updated_at';

  // Report Fields
  static const String reportTitle = 'title';
  static const String reportContent = 'content';
  static const String reportType = 'type';
  static const String reportStatus = 'status';
  static const String reportCreatorId = 'creator_id';
  static const String reportCreatorName = 'creator_name';
  static const String reportAssignedTo = 'assigned_to';
  static const String reportCreatedAt = 'created_at';
  static const String reportUpdatedAt = 'updated_at';
  static const String reportClosedAt = 'closed_at';

  // Message Fields
  static const String messageContent = 'content';
  static const String messageSenderId = 'sender_id';
  static const String messageSenderName = 'sender_name';
  static const String messageTimestamp = 'timestamp';
  static const String messageIsRead = 'is_read';

  // Chat Room Fields
  static const String chatRoomName = 'name';
  static const String chatRoomType = 'type';
  static const String chatRoomParticipants = 'participants';
  static const String chatRoomLastMessage = 'last_message';
  static const String chatRoomLastMessageTime = 'last_message_time';
  static const String chatRoomCreatedBy = 'created_by';
  static const String chatRoomCreatedAt = 'created_at';

  // Good Deed Fields
  static const String goodDeedContent = 'content';
  static const String goodDeedCreatorId = 'creator_id';
  static const String goodDeedLikesCount = 'likes_count';
  static const String goodDeedPrayersCount = 'prayers_count';
  static const String goodDeedCreatedAt = 'created_at';

  // Meal Item Fields
  static const String mealItemName = 'name';
  static const String mealItemPrice = 'price';
  static const String mealItemCategory = 'category';
  static const String mealItemIsAvailable = 'is_available';

  // Meal Order Fields
  static const String mealOrderUserId = 'user_id';
  static const String mealOrderUserName = 'user_name';
  static const String mealOrderItems = 'items';
  static const String mealOrderTotal = 'total';
  static const String mealOrderIsPaid = 'is_paid';
  static const String mealOrderDate = 'date';
  static const String mealOrderCreatedAt = 'created_at';
  static const String mealsCollection = 'meals_collection';
  static const String mealItemsCollection = 'meal_items';
  static const String mealOrdersCollection = 'meal_orders_collection';

  // Notification Fields
  static const String notificationTitle = 'title';
  static const String notificationBody = 'body';
  static const String notificationType = 'type';
  static const String notificationReferenceId = 'reference_id';
  static const String notificationIsRead = 'is_read';
  static const String notificationCreatedAt = 'created_at';

  // Department Fields
  static const String departmentName = 'name';
  static const String departmentDescription = 'description';
  static const String departmentManagerId = 'manager_id';
  static const String departmentManagerName = 'manager_name';

  // Settings Fields
  static const String settingKey = 'key';
  static const String settingValue = 'value';
  static const String settingUpdatedAt = 'updated_at';

  // Points Fields
  static const String pointsUserId = 'user_id';
  static const String pointsValue = 'value';
  static const String pointsReason = 'reason';
  static const String pointsMonth = 'month';
  static const String pointsYear = 'year';
  static const String pointsCreatedAt = 'created_at';
}

class UserRole {
  UserRole._();

  static const String employee = 'employee';
  static const String manager = 'manager';
  static const String superAdmin = 'super_admin';
}

class TaskPriority {
  TaskPriority._();

  static const String high = 'high';
  static const String medium = 'medium';
  static const String low = 'low';
}

class TaskStatus {
  TaskStatus._();

  static const String notStarted = 'not_started';
  static const String inProgress = 'in_progress';
  static const String inReview = 'in_review';
  static const String completed = 'completed';
  static const String late = 'late';
}

class ComplaintStatus {
  ComplaintStatus._();

  static const String pending = 'pending';
  static const String inProgress = 'in_progress';
  static const String resolved = 'resolved';
  static const String closed = 'closed';
}

class IdeaStatus {
  IdeaStatus._();

  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String rejected = 'rejected';
  static const String implemented = 'implemented';
}

class ReportStatus {
  ReportStatus._();

  static const String open = 'open';
  static const String inProgress = 'in_progress';
  static const String resolved = 'resolved';
  static const String closed = 'closed';
}

class AnnouncementType {
  AnnouncementType._();

  static const String meeting = 'meeting';
  static const String holiday = 'holiday';
  static const String decision = 'decision';
  static const String news = 'news';
  static const String alert = 'alert';
}

class ComplaintType {
  ComplaintType._();

  static const String breakdown = 'breakdown';
  static const String printer = 'printer';
  static const String internet = 'internet';
  static const String ac = 'ac';
  static const String cleanliness = 'cleanliness';
  static const String electricity = 'electricity';
  static const String other = 'other';
}

class ReportType {
  ReportType._();

  static const String breakdown = 'breakdown';
  static const String printer = 'printer';
  static const String internet = 'internet';
  static const String ac = 'ac';
  static const String cleanliness = 'cleanliness';
  static const String electricity = 'electricity';
  static const String other = 'other';
}

class ChatRoomType {
  ChatRoomType._();

  static const String individual = 'individual';
  static const String department = 'department';
}

class MealCategory {
  MealCategory._();

  static const String sandwiches = 'ساندوتشات';
  static const String pies = 'فطير';
  static const String pizza = 'بيتزا';
  static const String drinks = 'مشروبات';
  static const String desserts = 'حلويات';
  static const String breakfast = 'إفطار';
  static const String shawarma = 'شاورما';
  static const String grills = 'مشويات';
  static const String macaroni = 'مكرونات';

  static const List<String> all = [
    sandwiches,
    pies,
    pizza,
    breakfast,
    shawarma,
    grills,
    drinks,
    desserts,
    macaroni,
  ];
}

class NotificationType {
  NotificationType._();

  static const String newTask = 'new_task';
  static const String taskDueSoon = 'task_due_soon';
  static const String newAnnouncement = 'new_announcement';
  static const String complaintReply = 'complaint_reply';
  static const String reportUpdate = 'report_update';
  static const String newMessage = 'new_message';
  static const String meetingReminder = 'meeting_reminder';
}
