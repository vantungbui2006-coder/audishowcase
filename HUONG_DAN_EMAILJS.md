# Hướng dẫn cấu hình EmailJS (nhận email cả trên localhost lẫn hosting online)

EmailJS cho phép gửi email trực tiếp từ trình duyệt khách hàng (JavaScript),
không cần server phải tự kết nối SMTP — nên hoạt động ở MỌI môi trường,
kể cả hosting miễn phí chặn SMTP như InfinityFree.

## Bước 1 — Đăng ký tài khoản

1. Vào https://www.emailjs.com → bấm "Sign Up" → đăng ký bằng email hoặc Google
2. Xác minh email nếu được yêu cầu

## Bước 2 — Kết nối Gmail của bạn

1. Sau khi đăng nhập, vào mục **"Email Services"** ở menu trái
2. Bấm **"Add New Service"**
3. Chọn **"Gmail"**
4. Bấm **"Connect Account"** → đăng nhập Gmail của bạn → cho phép quyền truy cập
   (đơn giản hơn App Password — chỉ cần đăng nhập Google bình thường)
5. Sau khi kết nối xong, **ghi lại "Service ID"** hiện ra (dạng `service_xxxxxxx`)

## Bước 3 — Tạo Email Template

1. Vào mục **"Email Templates"** ở menu trái → bấm **"Create New Template"**
2. Ở khung soạn nội dung email, xóa nội dung mẫu, thay bằng:
   - **Subject** (tiêu đề email): gõ `{{subject}}`
   - **Content** (nội dung email): gõ `{{message}}`
3. Ở mục **"To Email"** (thường nằm trong tab "Settings" của template), điền
   đúng địa chỉ Gmail của BẠN (nơi bạn muốn nhận thông báo)
4. Bấm **"Save"**
5. **Ghi lại "Template ID"** hiện ra (dạng `template_xxxxxxx`)

## Bước 4 — Lấy Public Key

1. Vào mục **"Account"** ở menu trái → tab **"General"**
2. Tìm và ghi lại **"Public Key"** (dạng chuỗi ký tự ngẫu nhiên)

## Bước 5 — Điền vào code

Mở file `js/emailjs-config.js`, điền 3 giá trị vừa lấy được:

```javascript
const EMAILJS_PUBLIC_KEY  = 'dán Public Key vào đây';
const EMAILJS_SERVICE_ID  = 'dán Service ID vào đây (service_xxxxxxx)';
const EMAILJS_TEMPLATE_ID = 'dán Template ID vào đây (template_xxxxxxx)';
```

Lưu file lại.

## Bước 6 — Kiểm tra hoạt động

**Trên localhost:**
1. Gửi thử form "ĐỂ LẠI THÔNG TIN" tại `http://localhost/audi-showcase/`
2. Mở Gmail — phải thấy 2 email tới (1 từ EmailJS, 1 từ Gmail SMTP cũ nếu
   `mail-config.php` đã cấu hình đúng) — có 2 email là bình thường, không phải lỗi

**Trên hosting (quan trọng nhất — đây là cái trước đây không gửi được):**
1. Upload lại 3 file mới: `includes/contact-form.php`, `order.php`,
   `js/emailjs-config.js`, `js/emailjs-notify.js` lên host qua File Manager
   (ghi đè lên file cũ)
2. Gửi thử form trên link online (VD: `http://vantung.lovestoblog.com`)
3. Mở Gmail — lần này phải thấy email tới dù đang test trên hosting

## Giới hạn cần biết

- Gói miễn phí EmailJS: **200 email/tháng** — dư dùng cho đồ án
- Nếu không thấy email, kiểm tra mục **Spam** trước
- Mở Console trình duyệt (F12 → tab Console) khi gửi form để xem có dòng
  lỗi màu đỏ nào từ `emailjs.send` không — giúp debug nhanh hơn
