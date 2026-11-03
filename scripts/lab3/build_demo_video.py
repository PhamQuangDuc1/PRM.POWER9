"""Compose reviewed local Power9 footage with the selected Vietnamese narration.

Raw takes remain ignored under .build; this script never captures a device,
connects to Firebase, synthesizes speech, or publishes the resulting video.
"""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import textwrap

ROOT = Path(__file__).resolve().parents[2]
WORK = ROOT / '.build/video-20261104'
RAW = WORK / 'raw'
RENDER = WORK / 'render'
CARDS = WORK / 'cards'
OUT = ROOT / 'output/lab3/video-20261104'
VOICE = OUT / 'narration'
for directory in (RENDER, CARDS, OUT):
    directory.mkdir(parents=True, exist_ok=True)
FFMPEG = next((ROOT / '.build/lab3-video-deps/imageio_ffmpeg/binaries').glob('ffmpeg*.exe'))
NARRATION = json.loads((VOICE / 'narration.json').read_text(encoding='utf-8'))
assert NARRATION['voice'] == 'vi-VN-HoaiMyNeural'
assert all(s['status'] == 'generated' for s in NARRATION['scenes'])
FONT = 'assets/fonts/BeVietnamPro-Regular.ttf'
BOLD = 'assets/fonts/BeVietnamPro-Bold.ttf'
FORCE = '--force' in sys.argv
ENCODE = ['-c:v', 'libx264', '-preset', 'fast', '-crf', '20', '-pix_fmt', 'yuv420p',
          '-r', '30', '-c:a', 'aac', '-b:a', '160k', '-ar', '48000', '-ac', '2',
          '-movflags', '+faststart']


def run(arguments, name, timeout=360):
    result = subprocess.run([str(FFMPEG), '-hide_banner', '-loglevel', 'warning', '-y', *map(str, arguments)],
                            cwd=ROOT, capture_output=True, timeout=timeout)
    (RENDER / (name + '.log')).write_bytes(result.stderr)
    assert result.returncode == 0, 'Render failed: ' + name + '; inspect local render log'


def text_file(name, value):
    path = CARDS / (name + '.txt')
    # The bundled font does not contain the arrow glyph used in source notes.
    path.write_text(value.replace('→', '/'), encoding='utf-8', newline='\n')
    return path.relative_to(ROOT).as_posix()


def draw(name, text, x, y, size=32, color='0x16354c', bold=False, spacing=14):
    path = text_file(name, text)
    return (f"drawtext=fontfile='{BOLD if bold else FONT}':textfile='{path}':"
            f'x={x}:y={y}:fontsize={size}:fontcolor={color}:line_spacing={spacing}')


def canvas(seconds):
    return ['-f', 'lavfi', '-i', f'color=c=0xf4f7fc:s=1920x1080:r=30:d={seconds}']


def audio_filter(index):
    return f'[{index}:a]loudnorm=I=-16:TP=-1.5:LRA=11,aresample=48000,adelay=1200:all=1,apad[a]'


discover = RENDER / '02-discover-continuity.mp4'
if not discover.exists():
    run(['-i', RAW / '02-discover-take3.mp4', '-i', RAW / '02-create-save-take1.mp4',
         '-filter_complex', '[0:v]trim=duration=20,setpts=PTS-STARTPTS[v0];'
         '[1:v]setpts=PTS-STARTPTS[v1];[v0][v1]concat=n=2:v=1:a=0[v]',
         '-map', '[v]', '-an', '-c:v', 'libx264', '-preset', 'fast', '-crf', '18',
         '-pix_fmt', 'yuv420p', '-r', '30', discover], 'discover-continuity')

auth_state = WORK / 'auth-private.json'
auth_verified = auth_state.exists() and json.loads(auth_state.read_text()).get('homeReturned', False)
intro_source = RAW / '01-intro-take1.mp4'
if auth_verified:
    intro_source = RENDER / '01-auth-continuity.mp4'
    if not intro_source.exists():
        privacy = draw('auth-transition', 'Đã lược bỏ bộ chọn Google\nđể giữ thông tin riêng', 95, 1090, 48, bold=True)
        run(['-i', RAW / '01-login-public.mp4', '-i', RAW / '01-home-after-signin.mp4',
             '-f', 'lavfi', '-i', 'color=c=0xf4f7fc:s=1080x2520:r=30:d=2',
             '-filter_complex', '[0:v]trim=duration=8,setpts=PTS-STARTPTS,fps=30,setsar=1[l];'
             '[1:v]trim=duration=24,setpts=PTS-STARTPTS,fps=30,setsar=1[h];'
             '[2:v]' + privacy + ',setsar=1[p];[l][p][h]concat=n=3:v=1:a=0[v]',
             '-map', '[v]', '-an', '-c:v', 'libx264', '-preset', 'fast', '-crf', '18',
             '-pix_fmt', 'yuv420p', '-r', '30', intro_source], 'auth-continuity')

phone_scenes = [
    ('01-intro', intro_source, 34, 'Một khoảng nghỉ nhỏ\ncho ngày làm việc',
     'Google Sign-In · dữ liệu riêng\nFlutter · MVVM · Firebase\n' +
     ('Login → bộ chọn ẩn → Home thật' if auth_verified else 'Đã đăng nhập trước khi quay'),
     'Xperia thật · Thao tác native qua USB'),
    ('02-discover', discover, 40, 'Khám phá và\ntạo lịch hoạt động',
     'Tìm không khớp → trạng thái rỗng\nThiếu giờ nhắc → báo lỗi\nLưu hợp lệ → xuất hiện ở Hôm nay', 'Có cắt nối hai đoạn quay · Tốc độ thực'),
    ('03-edit', '03-edit-take4.mp4', 43, 'Hủy sửa giữ nguyên.\nLưu sửa cập nhật.',
     'Hủy → giữ “Chưa chọn giờ”\nLưu → giờ mới 11:00\nTổng số lịch vẫn là 1\nĐây là demo native, không cộng ARTEMIS', 'TC10[3] ARTEMIS vẫn chưa đạt'),
    ('04-checkin', '04-checkin-take1.mp4', 32, 'Ghi nhận rồi hoàn tác',
     'Check-in → tiến độ tăng\nHoàn tác → lịch vẫn còn\nCheck-in không đo thời gian', 'Không tự lấy thời lượng gợi ý làm thời gian thực'),
    ('05-timer', '05-timer-take2.mp4', 47, 'Timer giữ đúng\ntrạng thái và thời gian',
     'Tạm dừng → Hôm nay → Ở lại\nTiếp tục → kết thúc sớm → ghi nhận\nThời lượng thực của lượt này: 19 giây\nTalkBack sau Ở lại: người dùng xác nhận', 'Các luồng TalkBack khác chưa kiểm tra hết'),
    ('06-delete', '06-delete-take1.mp4', 36, 'Xóa lịch,\ngiữ lịch sử',
     'Giữ lịch → dữ liệu không thay đổi\nXác nhận xóa → bỏ lịch\nCompletion vẫn còn trong Tiến độ', 'Đã dọn đúng dữ liệu của lượt quay và đối chiếu server'),
    ('07-pdf', '07-pdf-take1.mp4', 37, 'Báo cáo PDF\ntrên thiết bị',
     '2 hoạt động trong bản báo cáo\nMở Android print preview thật\nLưu đám mây đang tắt\nChưa đạt upload Storage production', 'Giữ Spark / billing tắt theo lựa chọn người dùng'),
]

chapters = []
for number, (scene, source, seconds, title, bullets, note) in enumerate(phone_scenes, start=1):
    source = source if isinstance(source, Path) else RAW / source
    target = RENDER / (scene + '.mp4')
    background = [
        'drawbox=x=120:y=42:w=510:h=996:color=white:t=fill',
        'drawbox=x=742:y=113:w=70:h=7:color=0x2863ae:t=fill',
        draw(scene+'-brand', 'POWER9  /  OFFICE ROUTINE', 742, 64, 24, '0x2863ae', True),
        draw(scene+'-title', title, 742, 164, 51, bold=True, spacing=12),
        draw(scene+'-bullets', bullets, 746, 385, 31, spacing=25),
        draw(scene+'-note', '\n'.join(textwrap.wrap(note, 53)), 746, 810, 25, '0x52677e'),
        draw(scene+'-footer', '04/11/2026  ·  Giọng tổng hợp: Hoài My', 746, 972, 22, '0x52677e'),
        draw(scene+'-page', f'{number:02d} / 09', 1710, 973, 24, '0x2863ae', True),
    ]
    filters = ('[0:v]' + ','.join(background) + '[bg];'
               '[1:v]crop=iw:ih-110:0:54,scale=-2:940,fps=30,setsar=1,'
               'tpad=stop_mode=clone:stop_duration=3[phone];'
               '[bg][phone]overlay=x=155:y=70:shortest=0:repeatlast=1[v];' + audio_filter(2))
    if FORCE or not target.exists():
        run([*canvas(seconds), '-i', source, '-i', VOICE / (scene+'.mp3'), '-filter_complex', filters,
             '-map', '[v]', '-map', '[a]', '-t', seconds, *ENCODE, target], scene)
    chapters.append({'id': scene, 'file': str(target), 'seconds': seconds,
                     'sourceType': 'real native phone recording', 'speed': 1})
    print(scene + ' rendered', flush=True)

# Split already generated narration at its original sentence boundaries to keep
# each Console page paired with its own words. No new speech request is made.
sentences = re.split(r'(?<=[.!?])\s+', NARRATION['scenes'][7]['text'])
assert len(sentences) == 10, 'Review Console narration grouping before export'
groups = [sentences[:2], sentences[2:4], sentences[4:5], sentences[5:7], sentences[7:]]
console_shots = [
    ('firestore', '08-firestore-move-walk-take1.mp4', 14, 'Firestore · danh mục activities / move-walk',
     'Dữ liệu danh mục trên project thật · không mở đường dẫn người dùng'),
    ('analytics', '08-analytics-waiting-take1.mp4', 18, 'Analytics DebugView · chưa nhận sự kiện',
     'Debug Device = 0 tại lúc quay · log SDK không thay xác nhận server'),
    ('crashlytics', '08-crashlytics-take1.mp4', 14, 'Crashlytics · issue test crash đã có',
     'Bằng chứng lịch sử 31/10/2026 · không gây crash mới trong video'),
    ('remote-config', '08-remote-config-take1.mp4', 14, 'Remote Config · giá trị hiện hành',
     'report_upload_enabled = false · chỉ xem, không publish cấu hình'),
    ('messaging', '08-messaging-take1.mp4', 18, 'FCM / Messaging · chiến dịch đã có',
     'Chiến dịch 01/11/2026 · không gửi thông báo mới trong buổi quay'),
]
console_files = []
for index, ((tag, source, seconds, title, note), group) in enumerate(zip(console_shots, groups)):
    audio = RENDER / ('08-'+tag+'-speech.mp3')
    parts = []
    for sentence in group:
        digest = hashlib.sha256((NARRATION['voice'] + NARRATION['rate'] + sentence).encode()).hexdigest()
        part = WORK / 'tts-parts' / (digest+'.mp3')
        assert part.exists(), 'Missing generated narration sentence'
        parts.append(part.read_bytes())
    audio.write_bytes(b''.join(parts))
    target = RENDER / ('08-'+tag+'.mp4')
    mask = ''
    if tag == 'remote-config':
        mask = (',drawbox=x=1490:y=345:w=310:h=565:color=0x242424:t=fill,' +
                draw('rc-private', 'Thông tin cá nhân\nđã được che', 1510, 425, 22, 'white'))
    filters = ('[1:v]crop=iw-116:ih-158:8:150' + mask +
               ',scale=1800:910:force_original_aspect_ratio=decrease,fps=30,setsar=1[screen];'
               '[0:v]' + draw('08-'+tag+'-title', title, 60, 28, 33, bold=True) + ',' +
               draw('08-'+tag+'-note', note, 60, 1035, 23, '0x52677e') + '[bg];'
               '[bg][screen]overlay=x=(W-w)/2:y=105:repeatlast=1[v];' + audio_filter(2))
    if FORCE or not target.exists():
        run([*canvas(seconds), '-i', RAW / source, '-i', audio, '-filter_complex', filters,
             '-map', '[v]', '-map', '[a]', '-t', seconds, *ENCODE, target], '08-'+tag)
    console_files.append(target)
    print('08-' + tag + ' rendered', flush=True)


def concatenate(files, target, tag):
    listing = RENDER / (tag+'-concat.txt')
    listing.write_text('\n'.join("file '" + str(p).replace('\\', '/') + "'" for p in files), encoding='utf-8')
    run(['-f', 'concat', '-safe', '0', '-i', listing, '-c', 'copy', '-movflags', '+faststart', target], tag)


console = RENDER / '08-console.mp4'
if FORCE or not console.exists():
    concatenate(console_files, console, 'console-combined')
chapters.append({'id': '08-console', 'file': str(console), 'seconds': sum(x[2] for x in console_shots),
                 'sourceType': 'real Firebase Console window recordings', 'speed': 1})

closing = RENDER / '09-results.mp4'
seconds = 48
closing_filters = [
    'drawbox=x=80:y=80:w=120:h=9:color=0x2863ae:t=fill',
    draw('09-brand', 'POWER9  /  KẾT QUẢ VÀ GIỚI HẠN', 80, 120, 26, '0x2863ae', True),
    draw('09-title', 'Bằng chứng đã có.\nGiới hạn được ghi rõ.', 80, 205, 62, bold=True),
    'drawbox=x=80:y=430:w=820:h=440:color=white:t=fill',
    'drawbox=x=950:y=430:w=890:h=440:color=white:t=fill',
    draw('09-done-title', 'ĐÃ KIỂM CHỨNG', 115, 470, 28, '0x2863ae', True),
    draw('09-done', '49 Flutter tests · analyzer sạch\n15 màn · 360 / 412 dp · chữ 1,5×\nHai tài khoản A → B → A\nTalkBack sau Ở lại: người dùng xác nhận', 115, 540, 28, spacing=27),
    draw('09-pending-title', 'CÒN THIẾU / NGOÀI PHẠM VI', 985, 470, 28, '0x99501c', True),
    draw('09-pending', 'ARTEMIS 32/33 · TC10[3] chưa đạt\nPro chưa đủ thời lượng\nDebugView chưa nhận event trong buổi quay\nTalkBack các luồng khác chưa kiểm tra hết\nStorage production giữ tắt theo Spark', 985, 535, 27, spacing=24),
    draw('09-footer', '04/11/2026  ·  App + Firebase Console thật  ·  Giọng tổng hợp Hoài My  ·  Không bật billing', 80, 975, 24, '0x52677e'),
]
if FORCE or not closing.exists():
    run([*canvas(seconds), '-i', VOICE / '09-results.mp3', '-filter_complex',
         '[0:v]' + ','.join(closing_filters) + '[v];' + audio_filter(1),
         '-map', '[v]', '-map', '[a]', '-t', seconds, *ENCODE, closing], '09-results')
chapters.append({'id': '09-results', 'file': str(closing), 'seconds': seconds,
                 'sourceType': 'current results title card; no simulated app or Console'})
target = OUT / 'Power9_Lab3_Demo_HoaiMy_20261104.mp4'
concatenate([Path(c['file']) for c in chapters], target, 'final-video')
offset = 0
public_chapters = []
for chapter in chapters:
    public_chapters.append({k:v for k,v in chapter.items() if k != 'file'} | {'startSeconds': offset})
    offset += chapter['seconds']
manifest = {'file': target.name, 'plannedDurationSeconds': offset,
            'sha256': hashlib.sha256(target.read_bytes()).hexdigest(), 'bytes': target.stat().st_size,
            'resolution': '1920x1080', 'videoCodec': 'H.264', 'audioCodec': 'AAC',
            'voice': NARRATION['voice'], 'chapters': public_chapters,
            'billingEnabled': False, 'storageProductionUploadDemonstrated': False,
            'analyticsDebugViewReceivedDuringRecording': False, 'newFcmMessageSent': False,
            'artemisVerifiedRunIds': 32, 'artemisTasksConsumed': 0,
            'publicSignInFlowRecorded': auth_verified, 'googleAccountPickerRecorded': False,
            'sameAccountRestoredAfterSignIn': auth_verified,
            'finalPlaybackAndPrivacyReviewComplete': False}
(OUT / 'video-manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps({'file': str(target), 'seconds': offset, 'bytes': target.stat().st_size,
                  'reviewStillRequired': True}), flush=True)
