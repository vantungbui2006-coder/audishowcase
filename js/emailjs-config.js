/**
 * js/emailjs-config.js — CẤU HÌNH EMAILJS
 *
 * ⚠️ BẮT BUỘC PHẢI SỬA 3 GIÁ TRỊ BÊN DƯỚI sau khi đăng ký EmailJS.
 * Xem hướng dẫn đầy đủ ở file HUONG_DAN_EMAILJS.md đi kèm.
 *
 * Khác với includes/mail-config.php (chứa mật khẩu, phải giấu kín),
 * file này CHẠY Ở TRÌNH DUYỆT KHÁCH HÀNG nên ai cũng xem được bằng
 * "View Source" — nhưng KHÔNG SAO, vì Public Key của EmailJS được
 * thiết kế để lộ ra công khai như vậy (không phải mật khẩu thật),
 * bản thân EmailJS giới hạn theo domain/số lượng gửi để chống lạm dụng.
 */
const EMAILJS_PUBLIC_KEY  = 'cFdah854dCsXT0vdE';
const EMAILJS_SERVICE_ID  = 'service_ppqlpjz';
const EMAILJS_TEMPLATE_ID = 'of4kkjj';
