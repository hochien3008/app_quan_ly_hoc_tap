const admin = require("firebase-admin");
const fs = require("fs");
const path = require("path");

// Khởi tạo Firebase Admin SDK
// Bạn cần tạo file service account key từ Firebase Console
const serviceAccount = require("../firebase-service-account-key.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "quanlyhoctap-a05de.appspot.com",
});

const bucket = admin.storage().bucket();

// Danh sách file nhạc cần upload
const musicFiles = [
  {
    localPath: "../assets/music/lofi_beats.mp3",
    firebasePath: "music/lofi_beats.mp3",
    name: "Lo-fi Beats",
  },
  {
    localPath: "../assets/music/nature_sounds.mp3",
    firebasePath: "music/nature_sounds.mp3",
    name: "Nature Sounds",
  },
  {
    localPath: "../assets/music/classical.mp3",
    firebasePath: "music/classical.mp3",
    name: "Classical",
  },
  {
    localPath: "../assets/music/white_noise.mp3",
    firebasePath: "music/white_noise.mp3",
    name: "White Noise",
  },
  {
    localPath: "../assets/music/cafe_ambience.mp3",
    firebasePath: "music/cafe_ambience.mp3",
    name: "Café Ambience",
  },
];

async function uploadMusicFiles() {
  console.log("🚀 Bắt đầu upload nhạc lên Firebase Storage...\n");

  for (const file of musicFiles) {
    try {
      const localFilePath = path.resolve(__dirname, file.localPath);

      // Kiểm tra file có tồn tại không
      if (!fs.existsSync(localFilePath)) {
        console.log(`❌ File không tồn tại: ${file.name}`);
        continue;
      }

      console.log(`📤 Đang upload: ${file.name}...`);

      // Upload file
      await bucket.upload(localFilePath, {
        destination: file.firebasePath,
        metadata: {
          contentType: "audio/mpeg",
          metadata: {
            name: file.name,
            uploadedAt: new Date().toISOString(),
          },
        },
      });

      // Set public access
      await bucket.file(file.firebasePath).makePublic();

      console.log(`✅ Upload thành công: ${file.name}`);
    } catch (error) {
      console.error(`❌ Lỗi khi upload ${file.name}:`, error.message);
    }
  }

  console.log("\n🎉 Hoàn thành upload nhạc!");
  process.exit(0);
}

// Chạy script
uploadMusicFiles().catch(console.error);
