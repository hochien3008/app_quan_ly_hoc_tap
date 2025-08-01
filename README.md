# StudyMate - Ứng dụng Quản lý Học tập

StudyMate là một ứng dụng di động được phát triển bằng Flutter, giúp sinh viên và người học quản lý việc học tập một cách hiệu quả.

## 🚀 Tính năng chính

### 📚 Quản lý Lịch học

- Tạo và quản lý lịch học thông minh
- Xem lịch theo ngày, tuần, tháng
- Thông báo nhắc nhở lịch học
- Tích hợp với Firebase để đồng bộ dữ liệu

### ⏰ Pomodoro Timer

- Phương pháp học tập hiệu quả với Pomodoro
- Tùy chỉnh thời gian học và nghỉ
- Phát nhạc nền trong khi học
- Thêm nhạc từ thiết bị cá nhân

### 🎵 Hệ thống Âm nhạc

- Nhạc nền có sẵn (Cafe ambience, Classical, Lofi beats, Nature sounds, White noise)
- Tải lên nhạc từ thiết bị
- Chuyển đổi nhạc mượt mà

### 👥 Quản lý Nhóm học tập

- Tạo và tham gia nhóm học tập
- Chia sẻ tài liệu và thông tin
- Tương tác với thành viên nhóm

### 📄 Quản lý Tài liệu

- Lưu trữ và tổ chức tài liệu học tập
- Tìm kiếm tài liệu nhanh chóng
- Chia sẻ tài liệu với nhóm

### 🔔 Hệ thống Thông báo

- Thông báo lịch học
- Nhắc nhở deadline
- Thông báo từ nhóm học tập

### 👤 Quản lý Hồ sơ

- Cập nhật thông tin cá nhân
- Theo dõi tiến độ học tập
- Cài đặt ứng dụng

## 🛠️ Công nghệ sử dụng

- **Frontend**: Flutter/Dart
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Storage (dự kiến)
- **State Management**: Provider
- **Audio**: audioplayers
- **File Picker**: file_picker

## 📱 Hình ảnh ứng dụng

### Màn hình Welcome

- Giao diện đăng nhập/đăng ký hiện đại
- Logo ứng dụng với thiết kế đẹp mắt
- Màu sắc xanh dương nhạt pha trắng

### Màn hình chính

- Bottom Navigation với 5 tab chính
- SliverAppBar đồng nhất
- Giao diện responsive

## 🚀 Cài đặt và Chạy

### Yêu cầu hệ thống

- Flutter SDK (phiên bản mới nhất)
- Android Studio / VS Code
- Android SDK hoặc iOS Simulator
- Firebase project

### Các bước cài đặt

1. **Clone repository**

```bash
git clone https://github.com/your-username/study-mate-app.git
cd study-mate-app
```

2. **Cài đặt dependencies**

```bash
flutter pub get
```

3. **Cấu hình Firebase**

   - Tạo project Firebase mới
   - Thêm ứng dụng Android/iOS
   - Tải file cấu hình:
     - `google-services.json` cho Android
     - `GoogleService-Info.plist` cho iOS
   - Đặt file vào thư mục tương ứng

4. **Chạy ứng dụng**

```bash
flutter run
```

## 📁 Cấu trúc dự án

```
lib/
├── config/
│   └── firebase_options.dart
├── core/
│   ├── constants/
│   ├── models/
│   ├── services/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── documents/
│   ├── groups/
│   ├── notifications/
│   ├── profile/
│   ├── schedule/
│   ├── settings/
│   └── study_session/
├── firebase/
├── localization/
├── routes/
├── shared/
└── main.dart
```

## 🔧 Cấu hình Firebase

### Authentication

- Email/Password authentication
- Anonymous authentication (Guest mode)

### Firestore Database

- Collections: users, schedules, groups, documents
- Security rules được cấu hình

### Storage (dự kiến)

- Lưu trữ file nhạc
- Lưu trữ tài liệu học tập

## 🎨 Thiết kế UI/UX

- **Màu sắc chính**: Xanh dương nhạt (#E3F2FD)
- **Màu accent**: Xanh dương (#2196F3)
- **Typography**: Modern và dễ đọc
- **Icons**: Material Design Icons
- **Layout**: Responsive và adaptive

## 📋 Tính năng đang phát triển

- [ ] Tích hợp Firebase Storage
- [ ] Chức năng chat trong nhóm
- [ ] Thống kê học tập
- [ ] Export/Import dữ liệu
- [ ] Dark mode
- [ ] Đa ngôn ngữ (Tiếng Việt/English)

## 🤝 Đóng góp

Chúng tôi rất hoan nghênh mọi đóng góp! Vui lòng:

1. Fork dự án
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit thay đổi (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

## 📄 Giấy phép

Dự án này được phân phối dưới giấy phép MIT. Xem file `LICENSE` để biết thêm chi tiết.

## 📞 Liên hệ

- **Tác giả**: Ho Minh Chien
- **Email**: your-email@example.com
- **GitHub**: [@your-username](https://github.com/your-username)

## 🙏 Lời cảm ơn

Cảm ơn tất cả những người đã đóng góp vào dự án này!

---

**StudyMate** - Your Personal Learning Assistant 📚✨
