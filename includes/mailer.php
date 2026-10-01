<?php
/**
 * includes/mailer.php — Gửi email thông báo cho admin khi có khách hàng mới.
 *
 * Dùng PHPMailer thay vì hàm mail() có sẵn của PHP vì:
 * hàm mail() gửi thẳng qua giao thức SMTP không mã hóa, hầu hết máy cá
 * nhân (kể cả localhost) không có sẵn mail server nên gửi luôn thất bại.
 * PHPMailer kết nối trực tiếp tới máy chủ SMTP của Gmail qua kết nối
 * mã hóa TLS, dùng chính tài khoản Gmail của bạn để gửi — đáng tin cậy
 * hơn nhiều cho môi trường localhost.
 */

require_once __DIR__ . '/PHPMailer/Exception.php';
require_once __DIR__ . '/PHPMailer/PHPMailer.php';
require_once __DIR__ . '/PHPMailer/SMTP.php';
require_once __DIR__ . '/mail-config.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception as PHPMailerException;

/**
 * sendAdminNotification — Gửi 1 email thông báo tới admin.
 *
 * @param string $subject   Tiêu đề email
 * @param string $bodyHtml  Nội dung email (dạng HTML, đã escape sẵn ở nơi gọi)
 * @return bool             true nếu gửi thành công, false nếu thất bại
 *
 * QUAN TRỌNG: hàm này KHÔNG throw exception ra ngoài — nếu gửi email lỗi
 * (VD: sai App Password, mất mạng), nó chỉ trả về false. Lý do: việc gửi
 * email chỉ là TÍNH NĂNG PHỤ — nếu để lỗi email làm crash cả trang, khách
 * hàng gửi form sẽ thấy lỗi dù dữ liệu của họ đã lưu vào database thành
 * công. Ta ghi lỗi vào error_log để admin tự kiểm tra, không hiện ra cho khách.
 */
function sendAdminNotification($subject, $bodyHtml) {
    $mail = new PHPMailer(true);

    try {
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';
        $mail->SMTPAuth   = true;
        $mail->Username   = MAIL_GMAIL_ADDRESS;
        $mail->Password   = str_replace(' ', '', MAIL_GMAIL_APP_PASSWORD); // xóa khoảng trắng nếu bạn dán nguyên cụm
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port       = 587;
        $mail->CharSet    = 'UTF-8';

        $mail->setFrom(MAIL_GMAIL_ADDRESS, MAIL_SENDER_NAME);
        $mail->addAddress(MAIL_ADMIN_RECEIVER);

        $mail->isHTML(true);
        $mail->Subject = $subject;
        $mail->Body    = $bodyHtml;

        $mail->send();
        return true;
    } catch (PHPMailerException $e) {
        // Ghi lỗi vào log server để bạn tự debug, KHÔNG hiện lỗi này cho khách hàng
        error_log('Gửi email thất bại: ' . $mail->ErrorInfo);
        return false;
    }
}
