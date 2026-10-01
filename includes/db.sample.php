<?php
/**
 * includes/db.sample.php — FILE MẪU, không chứa mật khẩu thật.
 *
 * Đây là file được đẩy lên GitHub công khai. Ai tải code về (kể cả chính
 * bạn khi cài lại trên máy mới) cần copy file này thành "db.php" (bỏ chữ
 * .sample) rồi điền mật khẩu thật của MÌNH vào — file "db.php" thật đã bị
 * .gitignore chặn, không bao giờ xuất hiện công khai trên GitHub.
 */

$host   = 'localhost';
$dbname = 'audi_showcase';
$user   = 'root';
$pass   = '';

$local_hostnames = ['localhost', 'vantungbui.local'];

if (!in_array($_SERVER['SERVER_NAME'], $local_hostnames, true)) {
    $host   = 'sqlxxx.infinityfree.com';        // Hostname MySQL của hosting bạn dùng
    $dbname = 'if0_xxxxxxx_audi_showcase';       // Tên database do hosting cấp
    $user   = 'if0_xxxxxxx';                      // Username MySQL do hosting cấp
    $pass   = 'mat-khau-mysql-host-cap';          // Mật khẩu MySQL do hosting cấp
}

try {
    $pdo = new PDO(
        "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
        $user,
        $pass,
        [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]
    );
} catch (PDOException $e) {
    die("Lỗi kết nối database: " . $e->getMessage());
}
