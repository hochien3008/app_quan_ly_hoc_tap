#!/usr/bin/env python3
"""
Script tạo file nhạc mẫu để test tính năng Pomodoro
Chạy script này để tạo các file .mp3 mẫu (1 giây silence)
"""

import os
import wave
import struct

def create_silent_mp3(filename, duration_seconds=1):
    """Tạo file MP3 silence để test"""
    # Tạo thư mục nếu chưa có
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    
    # Tạo file WAV silence trước
    wav_filename = filename.replace('.mp3', '.wav')
    
    # Thông số audio
    sample_rate = 44100
    channels = 1
    sample_width = 2  # 16-bit
    
    # Tạo file WAV
    with wave.open(wav_filename, 'w') as wav_file:
        wav_file.setnchannels(channels)
        wav_file.setsampwidth(sample_width)
        wav_file.setframerate(sample_rate)
        
        # Tạo silence data
        num_frames = int(sample_rate * duration_seconds)
        silence_data = struct.pack('<h', 0) * num_frames
        wav_file.writeframes(silence_data)
    
    print(f"✅ Đã tạo file: {wav_filename}")
    print(f"⚠️  Lưu ý: Đây là file WAV silence. Bạn cần convert sang MP3 hoặc thay bằng file nhạc thật.")

def main():
    print("🎵 Tạo file nhạc mẫu cho Pomodoro...\n")
    
    # Danh sách file nhạc cần tạo
    music_files = [
        "assets/music/lofi_beats.wav",
        "assets/music/nature_sounds.wav", 
        "assets/music/classical.wav",
        "assets/music/white_noise.wav",
        "assets/music/cafe_ambience.wav"
    ]
    
    for file_path in music_files:
        create_silent_mp3(file_path)
    
    print("\n📋 Hướng dẫn tiếp theo:")
    print("1. Thay thế các file .wav bằng file .mp3 thật")
    print("2. Hoặc sử dụng tool convert WAV sang MP3")
    print("3. Upload lên Firebase Storage bằng script Node.js")
    print("\n💡 Gợi ý: Bạn có thể tải nhạc miễn phí từ:")
    print("   - https://freemusicarchive.org/")
    print("   - https://incompetech.com/")
    print("   - https://pixabay.com/music/")

if __name__ == "__main__":
    main() 