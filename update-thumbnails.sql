-- =========================================================
-- update-thumbnails.sql — Gán ảnh đại diện cho từng xe
-- Chạy trong phpMyAdmin (tab SQL) SAU KHI đã copy đủ file ảnh
-- vào thư mục images/cars/ với đúng tên như bảng dưới đây.
--
-- Xe nào bạn chưa có ảnh thì XÓA dòng UPDATE tương ứng đi
-- (hoặc cứ để nguyên cũng không lỗi gì — chỉ là ảnh sẽ không
-- hiển thị vì file không tồn tại, trang vẫn chạy bình thường).
-- =========================================================

UPDATE cars SET thumbnail = 'a1-sportback.jpg' WHERE model_slug = 'a1-sportback';
UPDATE cars SET thumbnail = 'a3-sedan.jpg'      WHERE model_slug = 'a3-sedan';
UPDATE cars SET thumbnail = 'a4.jpg'            WHERE model_slug = 'a4';
UPDATE cars SET thumbnail = 'a6.jpg'            WHERE model_slug = 'a6';
UPDATE cars SET thumbnail = 'a8.jpg'            WHERE model_slug = 'a8';
UPDATE cars SET thumbnail = 'q3.jpg'            WHERE model_slug = 'q3';
UPDATE cars SET thumbnail = 'q5.jpg'            WHERE model_slug = 'q5';
UPDATE cars SET thumbnail = 'q7.jpg'            WHERE model_slug = 'q7';
UPDATE cars SET thumbnail = 'q8.jpg'            WHERE model_slug = 'q8';
UPDATE cars SET thumbnail = 'tt-coupe.jpg'      WHERE model_slug = 'tt-coupe';
UPDATE cars SET thumbnail = 'r8-v10.jpg'        WHERE model_slug = 'r8-v10';
UPDATE cars SET thumbnail = 'rs6-avant.jpg'     WHERE model_slug = 'rs6-avant';
