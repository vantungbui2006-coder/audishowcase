<?php
/**
 * includes/mail-config.sample.php — FILE MẪU, không chứa mật khẩu thật.
 *
 * Copy file này thành "mail-config.php" (bỏ chữ .sample) rồi điền Gmail +
 * App Password thật của bạn vào. Xem hướng dẫn lấy App Password ở file
 * HUONG_DAN_GMAIL.md. File "mail-config.php" thật đã bị .gitignore chặn,
 * không bao giờ xuất hiện công khai trên GitHub.
 */

define('MAIL_GMAIL_ADDRESS', 'ten-cua-ban@gmail.com');
define('MAIL_GMAIL_APP_PASSWORD', 'xxxx xxxx xxxx xxxx');
define('MAIL_ADMIN_RECEIVER', 'ten-cua-ban@gmail.com');
define('MAIL_SENDER_NAME', 'Audi Showcase - Website Demo');
