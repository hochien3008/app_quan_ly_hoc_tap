# Music Assets

Thư mục này chứa các file nhạc cho tính năng Pomodoro.

## Cấu trúc file cần có:

- `lofi_beats.mp3` - Nhạc Lo-fi Beats
- `nature_sounds.mp3` - Âm thanh thiên nhiên
- `classical.mp3` - Nhạc cổ điển
- `white_noise.mp3` - Tiếng ồn trắng
- `cafe_ambience.mp3` - Âm thanh quán café

## Hướng dẫn upload lên Firebase Storage:

1. Đăng nhập vào Firebase Console
2. Vào Storage
3. Tạo thư mục `music/`
4. Upload các file .mp3 vào thư mục `music/`
5. Đảm bảo tên file khớp với cấu hình trong `MusicService`

## Lưu ý:

- File nhạc nên có kích thước < 10MB để tải nhanh
- Format MP3 được khuyến nghị
- Chất lượng 128kbps là phù hợp cho background music
