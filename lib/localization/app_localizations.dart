import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Auth
      'welcome': 'Welcome',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'username': 'Username',
      'forgotPassword': 'Forgot Password?',
      'dontHaveAccount': "Don't have an account?",
      'alreadyHaveAccount': 'Already have an account?',
      'signUp': 'Sign Up',
      'signIn': 'Sign In',
      'signOut': 'Sign Out',

      // Dashboard
      'dashboard': 'Dashboard',
      'today': 'Today',
      'upcoming': 'Upcoming',
      'recent': 'Recent',
      'quickActions': 'Quick Actions',
      'viewAll': 'View All',

      // Schedule
      'schedule': 'Schedule',
      'addEvent': 'Add Event',
      'editEvent': 'Edit Event',
      'deleteEvent': 'Delete Event',
      'eventTitle': 'Event Title',
      'eventDescription': 'Event Description',
      'startTime': 'Start Time',
      'endTime': 'End Time',
      'location': 'Location',
      'subject': 'Subject',
      'teacher': 'Teacher',
      'room': 'Room',
      'recurring': 'Recurring',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',

      // Study
      'study': 'Study',
      'pomodoro': 'Pomodoro',
      'timer': 'Timer',
      'work': 'Work',
      'break': 'Break',
      'longBreak': 'Long Break',
      'start': 'Start',
      'pause': 'Pause',
      'resume': 'Resume',
      'stop': 'Stop',
      'reset': 'Reset',
      'skip': 'Skip',
      'workSession': 'Work Session',
      'breakSession': 'Break Session',
      'completedSessions': 'Completed Sessions',
      'totalStudyTime': 'Total Study Time',

      // Documents
      'documents': 'Documents',
      'uploadDocument': 'Upload Document',
      'documentTitle': 'Document Title',
      'documentDescription': 'Document Description',
      'fileType': 'File Type',
      'fileSize': 'File Size',
      'uploadDate': 'Upload Date',
      'lastAccessed': 'Last Accessed',
      'favorite': 'Favorite',
      'searchDocuments': 'Search Documents',
      'noDocuments': 'No documents found',

      // Groups
      'groups': 'Groups',
      'studyGroups': 'Study Groups',
      'createGroup': 'Create Group',
      'joinGroup': 'Join Group',
      'leaveGroup': 'Leave Group',
      'groupName': 'Group Name',
      'groupDescription': 'Group Description',
      'groupType': 'Group Type',
      'privacy': 'Privacy',
      'public': 'Public',
      'private': 'Private',
      'inviteOnly': 'Invite Only',
      'members': 'Members',
      'admins': 'Admins',
      'maxMembers': 'Max Members',
      'groupChat': 'Group Chat',
      'sendMessage': 'Send Message',
      'noGroups': 'No groups found',

      // Profile
      'profile': 'Profile',
      'editProfile': 'Edit Profile',
      'settings': 'Settings',
      'notifications': 'Notifications',
      'displayName': 'Display Name',
      'bio': 'Bio',
      'phone': 'Phone',
      'dateOfBirth': 'Date of Birth',
      'preferences': 'Preferences',
      'language': 'Language',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'about': 'About',
      'help': 'Help',
      'feedback': 'Feedback',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',

      // Common
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'info': 'Information',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'close': 'Close',
      'back': 'Back',
      'next': 'Next',
      'previous': 'Previous',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'refresh': 'Refresh',
      'retry': 'Retry',
      'noData': 'No data available',
      'noInternet': 'No internet connection',
      'tryAgain': 'Try Again',

      // Time
      'yesterday': 'Yesterday',
      'tomorrow': 'Tomorrow',
      'thisWeek': 'This Week',
      'lastWeek': 'Last Week',
      'nextWeek': 'Next Week',
      'thisMonth': 'This Month',
      'lastMonth': 'Last Month',
      'nextMonth': 'Next Month',
      'overdue': 'Overdue',
      'dueToday': 'Due Today',
      'dueTomorrow': 'Due Tomorrow',

      // Status
      'pending': 'Pending',
      'inProgress': 'In Progress',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'draft': 'Draft',
      'published': 'Published',
      'archived': 'Archived',
    },
    'vi': {
      // Auth
      'welcome': 'Chào mừng',
      'login': 'Đăng nhập',
      'register': 'Đăng ký',
      'email': 'Email',
      'password': 'Mật khẩu',
      'confirmPassword': 'Xác nhận mật khẩu',
      'username': 'Tên đăng nhập',
      'forgotPassword': 'Quên mật khẩu?',
      'dontHaveAccount': 'Chưa có tài khoản?',
      'alreadyHaveAccount': 'Đã có tài khoản?',
      'signUp': 'Đăng ký',
      'signIn': 'Đăng nhập',
      'signOut': 'Đăng xuất',

      // Dashboard
      'dashboard': 'Bảng điều khiển',
      'today': 'Hôm nay',
      'upcoming': 'Sắp tới',
      'recent': 'Gần đây',
      'quickActions': 'Thao tác nhanh',
      'viewAll': 'Xem tất cả',

      // Schedule
      'schedule': 'Lịch trình',
      'addEvent': 'Thêm sự kiện',
      'editEvent': 'Chỉnh sửa sự kiện',
      'deleteEvent': 'Xóa sự kiện',
      'eventTitle': 'Tiêu đề sự kiện',
      'eventDescription': 'Mô tả sự kiện',
      'startTime': 'Thời gian bắt đầu',
      'endTime': 'Thời gian kết thúc',
      'location': 'Địa điểm',
      'subject': 'Môn học',
      'teacher': 'Giáo viên',
      'room': 'Phòng học',
      'recurring': 'Lặp lại',
      'save': 'Lưu',
      'cancel': 'Hủy',
      'delete': 'Xóa',

      // Study
      'study': 'Học tập',
      'pomodoro': 'Pomodoro',
      'timer': 'Đồng hồ đếm ngược',
      'work': 'Làm việc',
      'break': 'Nghỉ ngơi',
      'longBreak': 'Nghỉ dài',
      'start': 'Bắt đầu',
      'pause': 'Tạm dừng',
      'resume': 'Tiếp tục',
      'stop': 'Dừng',
      'reset': 'Đặt lại',
      'skip': 'Bỏ qua',
      'workSession': 'Phiên làm việc',
      'breakSession': 'Phiên nghỉ ngơi',
      'completedSessions': 'Phiên đã hoàn thành',
      'totalStudyTime': 'Tổng thời gian học',

      // Documents
      'documents': 'Tài liệu',
      'uploadDocument': 'Tải lên tài liệu',
      'documentTitle': 'Tiêu đề tài liệu',
      'documentDescription': 'Mô tả tài liệu',
      'fileType': 'Loại tệp',
      'fileSize': 'Kích thước tệp',
      'uploadDate': 'Ngày tải lên',
      'lastAccessed': 'Truy cập lần cuối',
      'favorite': 'Yêu thích',
      'searchDocuments': 'Tìm kiếm tài liệu',
      'noDocuments': 'Không tìm thấy tài liệu',

      // Groups
      'groups': 'Nhóm học tập',
      'studyGroups': 'Nhóm học tập',
      'createGroup': 'Tạo nhóm',
      'joinGroup': 'Tham gia nhóm',
      'leaveGroup': 'Rời nhóm',
      'groupName': 'Tên nhóm',
      'groupDescription': 'Mô tả nhóm',
      'groupType': 'Loại nhóm',
      'privacy': 'Quyền riêng tư',
      'public': 'Công khai',
      'private': 'Riêng tư',
      'inviteOnly': 'Chỉ mời',
      'members': 'Thành viên',
      'admins': 'Quản trị viên',
      'maxMembers': 'Số thành viên tối đa',
      'groupChat': 'Trò chuyện nhóm',
      'sendMessage': 'Gửi tin nhắn',
      'noGroups': 'Không tìm thấy nhóm',

      // Profile
      'profile': 'Hồ sơ',
      'editProfile': 'Chỉnh sửa hồ sơ',
      'settings': 'Cài đặt',
      'notifications': 'Thông báo',
      'displayName': 'Tên hiển thị',
      'bio': 'Tiểu sử',
      'phone': 'Số điện thoại',
      'dateOfBirth': 'Ngày sinh',
      'preferences': 'Tùy chọn',
      'language': 'Ngôn ngữ',
      'theme': 'Giao diện',
      'light': 'Sáng',
      'dark': 'Tối',
      'system': 'Hệ thống',
      'about': 'Giới thiệu',
      'help': 'Trợ giúp',
      'feedback': 'Phản hồi',
      'privacyPolicy': 'Chính sách bảo mật',
      'termsOfService': 'Điều khoản sử dụng',

      // Common
      'loading': 'Đang tải...',
      'error': 'Lỗi',
      'success': 'Thành công',
      'warning': 'Cảnh báo',
      'info': 'Thông tin',
      'confirm': 'Xác nhận',
      'yes': 'Có',
      'no': 'Không',
      'ok': 'OK',
      'close': 'Đóng',
      'back': 'Quay lại',
      'next': 'Tiếp theo',
      'previous': 'Trước đó',
      'search': 'Tìm kiếm',
      'filter': 'Lọc',
      'sort': 'Sắp xếp',
      'refresh': 'Làm mới',
      'retry': 'Thử lại',
      'noData': 'Không có dữ liệu',
      'noInternet': 'Không có kết nối internet',
      'tryAgain': 'Thử lại',

      // Time
      'yesterday': 'Hôm qua',
      'tomorrow': 'Ngày mai',
      'thisWeek': 'Tuần này',
      'lastWeek': 'Tuần trước',
      'nextWeek': 'Tuần sau',
      'thisMonth': 'Tháng này',
      'lastMonth': 'Tháng trước',
      'nextMonth': 'Tháng sau',
      'overdue': 'Quá hạn',
      'dueToday': 'Hạn hôm nay',
      'dueTomorrow': 'Hạn ngày mai',

      // Status
      'pending': 'Chờ xử lý',
      'inProgress': 'Đang thực hiện',
      'completed': 'Hoàn thành',
      'cancelled': 'Đã hủy',
      'draft': 'Bản nháp',
      'published': 'Đã xuất bản',
      'archived': 'Đã lưu trữ',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('vi', 'VN'),
  ];
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
