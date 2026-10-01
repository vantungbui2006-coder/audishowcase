-- =========================================================
-- DATABASE: audi_showcase — BẢN DÀNH RIÊNG CHO HOSTING (InfinityFree...)
-- Khác bản gốc database.sql: KHÔNG có 2 dòng CREATE DATABASE / USE,
-- vì tài khoản hosting chia sẻ không có quyền chạy 2 lệnh đó — bạn
-- đã tự tạo database qua Control Panel rồi, chỉ cần import thẳng
-- các bảng vào database đó (phpMyAdmin tự làm việc trong đúng
-- database bạn đang chọn, không cần USE).
-- =========================================================

-- BẢNG 1: cars — thông tin tổng quan từng mẫu xe
-- ---------------------------------------------------------
CREATE TABLE cars (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    model_name      VARCHAR(100)   NOT NULL,          -- VD: "Audi RS6 Avant"
    model_slug      VARCHAR(100)   NOT NULL UNIQUE,    -- VD: "rs6-avant" (dùng cho URL)
    generation_year VARCHAR(20)    NOT NULL,           -- VD: "2020 - 2024"
    category        ENUM('Sedan','SUV','Coupe','Sports','Hatchback') NOT NULL,
    price_vnd       DECIMAL(15,0)  NOT NULL,           -- giá tham khảo, đơn vị VNĐ
    horsepower      INT            NOT NULL,           -- mã lực (hp)
    top_speed_kmh    INT            NOT NULL,           -- tốc độ tối đa km/h
    accel_0_100     DECIMAL(3,1)   NOT NULL,           -- 0-100km/h, đơn vị giây
    engine_type     VARCHAR(100)   NOT NULL,           -- VD: "V8 4.0L Twin-Turbo"
    main_color      VARCHAR(50)    NOT NULL,           -- màu chủ đạo hiển thị
    short_desc      VARCHAR(255)   NOT NULL,           -- mô tả ngắn dưới tên xe
    full_desc       TEXT           NOT NULL,           -- mô tả chi tiết (trang detail)
    thumbnail       VARCHAR(255)   DEFAULT NULL,        -- đường dẫn ảnh đại diện
    created_at      TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- BẢNG 2: car_images — thư viện ảnh cho từng xe (ngoại thất/nội thất/động cơ)
-- ---------------------------------------------------------
CREATE TABLE car_images (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    car_id      INT NOT NULL,
    image_url   VARCHAR(255) NOT NULL,
    image_type  ENUM('exterior','interior','engine','wheel') NOT NULL,
    sort_order  INT DEFAULT 0,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- BẢNG 3: car_parts — mô tả bộ phận xe (thân xe, khung, động cơ...)
-- Dùng cho trang chi tiết xe ở Giai đoạn 2
-- ---------------------------------------------------------
CREATE TABLE car_parts (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    car_id       INT NOT NULL,
    part_name    VARCHAR(100) NOT NULL,   -- VD: "Khung gầm nhôm ASF"
    part_desc    TEXT NOT NULL,
    part_image   VARCHAR(255) DEFAULT NULL,
    sort_order   INT DEFAULT 0,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- BẢNG 4: inquiries — khách hàng để lại thông tin liên hệ
-- ---------------------------------------------------------
CREATE TABLE inquiries (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    car_id           INT DEFAULT NULL,
    full_name        VARCHAR(100) NOT NULL,
    phone            VARCHAR(20)  NOT NULL,
    email            VARCHAR(100) DEFAULT NULL,
    address          VARCHAR(255) DEFAULT NULL,   -- địa chỉ khách hàng
    referral_source  VARCHAR(100) DEFAULT NULL,   -- người/kênh giới thiệu
    message          TEXT DEFAULT NULL,
    status           ENUM('new','contacted','closed') DEFAULT 'new',
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- BẢNG 5: orders — đơn hàng demo (thanh toán QR / tiền mặt)
-- LƯU Ý: đây là MÔ PHỔNG cho đồ án học tập, KHÔNG kết nối cổng
-- thanh toán thật. Không dùng để xử lý giao dịch tiền thật.
-- ---------------------------------------------------------
CREATE TABLE orders (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    car_id          INT NOT NULL,
    customer_name   VARCHAR(100) NOT NULL,
    phone           VARCHAR(20)  NOT NULL,
    payment_method  ENUM('qr','cash') NOT NULL,
    amount_vnd      DECIMAL(15,0) NOT NULL,
    status          ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- BẢNG 6: customer_documents — giấy tờ demo (CCCD/GPLX)
-- LƯU Ý QUAN TRỌNG: chỉ dùng dữ liệu GIẢ ĐỊNH khi demo/báo cáo.
-- KHÔNG được nhập CCCD/GPLX thật của bất kỳ ai vào bảng này —
-- đây là dữ liệu cá nhân nhạy cảm, việc thu thập/lưu trữ dữ liệu
-- thật chịu ràng buộc của Nghị định 13/2023/NĐ-CP về bảo vệ dữ
-- liệu cá nhân. Với đồ án, hãy dùng số CCCD giả (VD: 000000000000).
-- ---------------------------------------------------------
CREATE TABLE customer_documents (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    order_id            INT NOT NULL,
    id_card_number      VARCHAR(20)  NOT NULL,   -- CCCD (demo)
    id_card_image       VARCHAR(255) DEFAULT NULL,
    license_number      VARCHAR(20)  DEFAULT NULL, -- GPLX (demo)
    license_image       VARCHAR(255) DEFAULT NULL,
    uploaded_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- DỮ LIỆU MẪU: 12 mẫu xe Audi từ đời cũ đến mới
-- Thông số tham khảo gần đúng thực tế để đồ án có tính thuyết phục
-- =========================================================
INSERT INTO cars
(model_name, model_slug, generation_year, category, price_vnd, horsepower, top_speed_kmh, accel_0_100, engine_type, main_color, short_desc, full_desc)
VALUES
('Audi A1 Sportback', 'a1-sportback', '2019 - 2023', 'Hatchback', 850000000, 116, 203, 9.5,
 '1.5L TFSI Turbo', '#C8102E',
 'Nhỏ gọn, linh hoạt, tinh thần thể thao trong từng khối hình.',
 'Audi A1 Sportback là mẫu hatchback hạng sang cỡ nhỏ, kết hợp thiết kế trẻ trung với công nghệ khoang lái kỹ thuật số Audi virtual cockpit, phù hợp cho đô thị.'),

('Audi A3 Sedan', 'a3-sedan', '2020 - 2024', 'Sedan', 1450000000, 150, 224, 8.4,
 '2.0L TFSI', '#1A1A2E',
 'Sedan hạng sang cỡ nhỏ, cân bằng giữa hiệu suất và tiện nghi.',
 'Audi A3 Sedan mang ngôn ngữ thiết kế Audi trưởng thành thu nhỏ, lưới tản nhiệt Singleframe đặc trưng, nội thất MMI touch hiện đại.'),

('Audi A4', 'a4', '2019 - 2023', 'Sedan', 1850000000, 190, 237, 7.3,
 '2.0L TFSI quattro', '#0F0F0F',
 'Chuẩn mực của phân khúc sedan hạng sang doanh nhân.',
 'Audi A4 là mẫu sedan chủ lực với hệ dẫn động quattro, cân bằng lý tưởng giữa vận hành thể thao và sự sang trọng tinh tế.'),

('Audi A6', 'a6', '2021 - 2024', 'Sedan', 2950000000, 245, 250, 6.0,
 '2.0L TFSI quattro', '#8B0000',
 'Đẳng cấp doanh nhân với công nghệ dẫn động tiên tiến.',
 'Audi A6 thế hệ mới sở hữu lưới tản nhiệt lớn, hệ thống đèn OLED, khoang lái công nghệ cao với hai màn hình cảm ứng MMI.'),

('Audi A8', 'a8', '2018 - 2023', 'Sedan', 4500000000, 340, 250, 5.4,
 '3.0L TFSI quattro', '#000000',
 'Sedan chủ lực hạng sang — đỉnh cao công nghệ và sự tĩnh lặng.',
 'Audi A8 là flagship sedan với hệ thống treo khí nén chủ động, ghế massage, và loạt công nghệ hỗ trợ lái bán tự động cấp độ 3.'),

('Audi Q3', 'q3', '2020 - 2024', 'SUV', 1750000000, 184, 213, 8.3,
 '2.0L TFSI', '#4A4A4A',
 'SUV cỡ nhỏ năng động, lý tưởng cho gia đình trẻ.',
 'Audi Q3 kết hợp phong cách SUV mạnh mẽ với không gian linh hoạt, phù hợp cho cả đô thị lẫn những chuyến đi xa.'),

('Audi Q5', 'q5', '2021 - 2024', 'SUV', 2650000000, 265, 237, 5.8,
 '2.0L TFSI quattro', '#2E2E2E',
 'SUV hạng sang bán chạy nhất, vận hành thể thao vượt trội.',
 'Audi Q5 là mẫu SUV cỡ trung cân bằng hoàn hảo giữa khả năng vận hành, không gian nội thất và công nghệ an toàn tiên tiến.'),

('Audi Q7', 'q7', '2020 - 2024', 'SUV', 3850000000, 335, 250, 5.9,
 '3.0L TFSI quattro', '#1C1C1C',
 'SUV 7 chỗ cao cấp, uy nghi và mạnh mẽ.',
 'Audi Q7 mang thiết kế bệ vệ, 3 hàng ghế rộng rãi, cùng hệ thống quattro huyền thoại cho khả năng vận hành mọi địa hình.'),

('Audi Q8', 'q8', '2019 - 2023', 'SUV', 4650000000, 340, 250, 5.6,
 '3.0L TFSI quattro', '#0D0D0D',
 'SUV coupe đầu bảng — tuyên ngôn phong cách và sức mạnh.',
 'Audi Q8 là sự kết hợp giữa dáng vóc SUV bệ vệ và đường mái coupe thể thao, đại diện cho đỉnh cao thiết kế SUV của Audi.'),

('Audi TT Coupe', 'tt-coupe', '2018 - 2023', 'Coupe', 2150000000, 230, 250, 6.0,
 '2.0L TFSI quattro', '#C0C0C0',
 'Coupe thể thao thuần chất, biểu tượng thiết kế bền vững.',
 'Audi TT là dòng coupe thể thao cỡ nhỏ với thiết kế mang tính biểu tượng gần như không đổi qua nhiều thế hệ, tập trung vào cảm giác lái.'),

('Audi R8 V10', 'r8-v10', '2019 - 2023', 'Sports', 9500000000, 570, 324, 3.4,
 'V10 5.2L tự nhiên', '#B22222',
 'Siêu xe đường phố — trái tim V10 thuần khiết.',
 'Audi R8 V10 là siêu xe hai chỗ ngồi với động cơ V10 hút khí tự nhiên, âm thanh động cơ đặc trưng không thể nhầm lẫn, hiệu suất đỉnh cao.'),

('Audi RS6 Avant', 'rs6-avant', '2020 - 2024', 'Sports', 6800000000, 600, 305, 3.6,
 'V8 4.0L Twin-Turbo', '#8B0000',
 'Station wagon nhanh nhất thế giới — thực dụng và điên rồ.',
 'Audi RS6 Avant là mẫu station wagon hiệu suất cao với động cơ V8 twin-turbo 600 mã lực, kết hợp không gian thực dụng với tốc độ siêu xe.');

-- =========================================================
-- DỮ LIỆU BỘ PHẬN XE (car_parts) cho 12 mẫu xe — xem chi tiết
-- lý do thiết kế trong file car_parts_seed.sql
-- =========================================================

-- ---------- Audi A1 Sportback ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'Thiết kế hatchback 5 cửa với lưới tản nhiệt Singleframe bát giác thu nhỏ, cụm đèn Full LED tiêu chuẩn, đường gân dập nổi dọc thân tạo cảm giác thể thao.', 1 FROM cars WHERE model_slug = 'a1-sportback'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Nền tảng MQB A0 chia sẻ với Volkswagen Polo, treo trước MacPherson, treo sau thanh xoắn, trọng lượng bản thân khoảng 1.2 tấn giúp xe linh hoạt trong đô thị.', 2 FROM cars WHERE model_slug = 'a1-sportback'
UNION ALL SELECT id, 'Động cơ', 'Động cơ 1.5L TFSI 4 xi-lanh tăng áp, 116 mã lực, mô-men xoắn 200Nm, hộp số 7 cấp S tronic ly hợp kép.', 3 FROM cars WHERE model_slug = 'a1-sportback'
UNION ALL SELECT id, 'Nội thất & Công nghệ', 'Màn hình Audi virtual cockpit 10.25 inch, hệ thống MMI touch, ghế bọc da/nỉ tùy chọn, không gian khoang lái tối giản tập trung vào người lái.', 4 FROM cars WHERE model_slug = 'a1-sportback';

-- ---------- Audi A3 Sedan ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'Dáng sedan 4 cửa mui thấp, đèn hậu OLED tùy chọn, tỷ lệ thân xe cân đối tạo cảm giác thể thao hơn bản Sportback.', 1 FROM cars WHERE model_slug = 'a3-sedan'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Nền tảng MQB Evo, treo đa liên kết phía sau (bản quattro), hệ thống lái trợ lực điện tinh chỉnh cho phản hồi nhanh.', 2 FROM cars WHERE model_slug = 'a3-sedan'
UNION ALL SELECT id, 'Động cơ', 'Động cơ 2.0L TFSI, 150 mã lực, mô-men xoắn 250Nm, hộp số 7 cấp S tronic.', 3 FROM cars WHERE model_slug = 'a3-sedan'
UNION ALL SELECT id, 'Nội thất & Công nghệ', 'Bảng táp-lô hướng người lái đặc trưng Audi, hệ thống âm thanh Bang & Olufsen tùy chọn, sạc không dây tích hợp.', 4 FROM cars WHERE model_slug = 'a3-sedan';

-- ---------- Audi A4 ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'Thiết kế sedan doanh nhân với lưới Singleframe rộng bản, đường gân dập sắc sảo dọc hông xe, hệ số cản gió Cd 0.27.', 1 FROM cars WHERE model_slug = 'a4'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Hệ dẫn động quattro ultra tự động ngắt cầu sau khi không cần thiết để tiết kiệm nhiên liệu, treo trước 5 thanh liên kết nhôm.', 2 FROM cars WHERE model_slug = 'a4'
UNION ALL SELECT id, 'Động cơ', 'Động cơ 2.0L TFSI tăng áp, 190 mã lực, mô-men xoắn 320Nm, hộp số tự động 7 cấp.', 3 FROM cars WHERE model_slug = 'a4'
UNION ALL SELECT id, 'Nội thất & Công nghệ', 'Ghế thể thao tùy chọn, hệ thống hỗ trợ lái Audi pre sense front, màn hình MMI 10.1 inch cảm ứng.', 4 FROM cars WHERE model_slug = 'a4';

-- ---------- Audi A6 ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'Lưới tản nhiệt Singleframe lớn mạ crôm, dải đèn LED matrix full, thân xe dài 4.94m tạo dáng vẻ uy nghi.', 1 FROM cars WHERE model_slug = 'a6'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Hệ thống treo khí nén thích ứng tùy chọn, kết cấu thép-nhôm hỗn hợp giảm trọng lượng.', 2 FROM cars WHERE model_slug = 'a6'
UNION ALL SELECT id, 'Động cơ', 'Động cơ 2.0L TFSI mild-hybrid 48V, 245 mã lực, hỗ trợ tăng tốc êm và tiết kiệm nhiên liệu khi nhả ga.', 3 FROM cars WHERE model_slug = 'a6'
UNION ALL SELECT id, 'Nội thất & Công nghệ', 'Hai màn hình cảm ứng MMI touch response xếp chồng, đèn viền nội thất 30 màu, hệ thống âm thanh Bang & Olufsen 3D.', 4 FROM cars WHERE model_slug = 'a6';

-- ---------- Audi A8 ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'Sedan flagship dài 5.17m, thân xe nhôm ASF (Audi Space Frame) giúp giảm trọng lượng đáng kể so với thép truyền thống.', 1 FROM cars WHERE model_slug = 'a8'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Hệ thống treo khí nén chủ động dự đoán địa hình qua camera, hệ dẫn động quattro tiêu chuẩn.', 2 FROM cars WHERE model_slug = 'a8'
UNION ALL SELECT id, 'Động cơ', 'Động cơ V6 3.0L TFSI tăng áp mild-hybrid, 340 mã lực, mô-men xoắn 500Nm, tăng tốc êm ái.', 3 FROM cars WHERE model_slug = 'a8'
UNION ALL SELECT id, 'Nội thất & Công nghệ', 'Ghế sau massage & duỗi chân, màn hình MMI kép cảm ứng có phản hồi rung, hệ thống lọc không khí ion hóa.', 4 FROM cars WHERE model_slug = 'a8';

-- ---------- Audi Q3 ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'SUV cỡ nhỏ với thiết kế vuông vức khỏe khoắn, khoảng sáng gầm xe 200mm phù hợp đa địa hình đô thị.', 1 FROM cars WHERE model_slug = 'q3'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Nền tảng MQB chia sẻ với Volkswagen Tiguan, hệ dẫn động quattro tùy chọn với khớp ly hợp đa đĩa.', 2 FROM cars WHERE model_slug = 'q3'
UNION ALL SELECT id, 'Động cơ', 'Động cơ 2.0L TFSI, 184 mã lực, hộp số 7 cấp S tronic.', 3 FROM cars WHERE model_slug = 'q3'
UNION ALL SELECT id, 'Nội thất & Công nghệ', 'Khoang hành lý linh hoạt 530-1525 lít khi gập ghế, màn hình virtual cockpit 10.25 inch tùy chọn.', 4 FROM cars WHERE model_slug = 'q3';

-- ---------- Audi Q5 ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'SUV cỡ trung với tỷ lệ cân đối, lưới tản nhiệt hình bát giác lớn, khoảng sáng gầm 209mm.', 1 FROM cars WHERE model_slug = 'q5'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Hệ dẫn động quattro với khớp ly hợp Haldex thế hệ 5, treo khí nén thích ứng tùy chọn.', 2 FROM cars WHERE model_slug = 'q5'
UNION ALL SELECT id, 'Động cơ', 'Động cơ 2.0L TFSI mild-hybrid, 265 mã lực, mô-men xoắn 370Nm.', 3 FROM cars WHERE model_slug = 'q5'
UNION ALL SELECT id, 'Nội thất & Công nghệ', 'Không gian 5 chỗ rộng rãi, cửa sổ trời toàn cảnh, hệ thống hỗ trợ đỗ xe 360 độ.', 4 FROM cars WHERE model_slug = 'q5';

-- ---------- Audi Q7 ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'SUV 7 chỗ cỡ lớn, thân xe dài 5.06m, khung nhôm-thép hỗn hợp giảm trọng lượng 325kg so với thế hệ trước.', 1 FROM cars WHERE model_slug = 'q7'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Hệ thống treo khí nén 5 chế độ, hệ dẫn động quattro với vi sai trung tâm tự khóa.', 2 FROM cars WHERE model_slug = 'q7'
UNION ALL SELECT id, 'Động cơ', 'Động cơ V6 3.0L TFSI mild-hybrid, 335 mã lực, mô-men xoắn 500Nm.', 3 FROM cars WHERE model_slug = 'q7'
UNION ALL SELECT id, 'Nội thất & Công nghệ', '3 hàng ghế linh hoạt gập điện, hệ thống giải trí hàng ghế sau, khoang hành lý tối đa 2050 lít.', 4 FROM cars WHERE model_slug = 'q7';

-- ---------- Audi Q8 ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'SUV coupe với đường mái dốc thể thao, vòm bánh xe mở rộng, đèn hậu OLED dải liền mạch toàn chiều rộng.', 1 FROM cars WHERE model_slug = 'q8'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Chia sẻ nền tảng MLB Evo với Q7 nhưng chỉnh treo khí nén thể thao hơn, vệt bánh xe rộng hơn tăng độ bám cua.', 2 FROM cars WHERE model_slug = 'q8'
UNION ALL SELECT id, 'Động cơ', 'Động cơ V6 3.0L TFSI mild-hybrid, 340 mã lực, mô-men xoắn 500Nm.', 3 FROM cars WHERE model_slug = 'q8'
UNION ALL SELECT id, 'Nội thất & Công nghệ', 'Khoang lái kết hợp 3 màn hình (đồng hồ kỹ thuật số, MMI, điều khiển điều hòa cảm ứng), ghế thể thao ốp da cao cấp.', 4 FROM cars WHERE model_slug = 'q8';

-- ---------- Audi TT Coupe ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'Coupe 2+2 với thiết kế mui thấp mang tính biểu tượng, ít thay đổi thiết kế cốt lõi qua nhiều thế hệ, hệ số cản gió Cd 0.30.', 1 FROM cars WHERE model_slug = 'tt-coupe'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Nền tảng MQB, trọng lượng nhẹ nhờ các chi tiết vỏ xe bằng nhôm ở nắp capo và cửa xe.', 2 FROM cars WHERE model_slug = 'tt-coupe'
UNION ALL SELECT id, 'Động cơ', 'Động cơ 2.0L TFSI, 230 mã lực, mô-men xoắn 370Nm, tăng tốc 0-100km/h trong 6.0 giây.', 3 FROM cars WHERE model_slug = 'tt-coupe'
UNION ALL SELECT id, 'Nội thất & Công nghệ', 'Khoang lái tối giản đặc trưng, cụm điều khiển điều hòa tích hợp trong núm vô-lăng, chỉ có màn hình virtual cockpit (không màn hình trung tâm riêng).', 4 FROM cars WHERE model_slug = 'tt-coupe';

-- ---------- Audi R8 V10 ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'Siêu xe 2 chỗ với khung gầm ASF nhôm-carbon hỗn hợp, động cơ đặt giữa sau, tỷ lệ phân bổ trọng lượng gần 50:50.', 1 FROM cars WHERE model_slug = 'r8-v10'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Treo đa liên kết thể thao, hệ dẫn động quattro thiên hướng cầu sau, lốp hiệu suất cao chuyên dụng.', 2 FROM cars WHERE model_slug = 'r8-v10'
UNION ALL SELECT id, 'Động cơ', 'Động cơ V10 5.2L hút khí tự nhiên (không tăng áp), 570 mã lực, dải vòng tua lên tới 8700 vòng/phút, âm thanh động cơ đặc trưng.', 3 FROM cars WHERE model_slug = 'r8-v10'
UNION ALL SELECT id, 'Nội thất & Công nghệ', 'Khoang lái phong cách đua xe với nút khởi động tích hợp trên vô-lăng, ghế đua ôm sát cơ thể, mọi thông tin hiển thị trên cụm đồng hồ ảo duy nhất.', 4 FROM cars WHERE model_slug = 'r8-v10';

-- ---------- Audi RS6 Avant ----------
INSERT INTO car_parts (car_id, part_name, part_desc, sort_order)
SELECT id, 'Thân xe & Ngoại thất', 'Thân xe station wagon (Avant) mở rộng vòm bánh 25mm mỗi bên so với A6 thường, ống xả kép hình oval đặc trưng RS.', 1 FROM cars WHERE model_slug = 'rs6-avant'
UNION ALL SELECT id, 'Khung gầm & Hệ thống treo', 'Hệ thống treo khí nén thể thao RS, hệ dẫn động quattro thiên hướng cầu sau, phanh gốm carbon tùy chọn.', 2 FROM cars WHERE model_slug = 'rs6-avant'
UNION ALL SELECT id, 'Động cơ', 'Động cơ V8 4.0L Twin-Turbo mild-hybrid, 600 mã lực, mô-men xoắn 800Nm, tăng tốc 0-100km/h chỉ 3.6 giây dù là xe 5 chỗ có khoang hành lý.', 3 FROM cars WHERE model_slug = 'rs6-avant'
UNION ALL SELECT id, 'Nội thất & Công nghệ', 'Ghế thể thao RS ốp da/Alcantara, logo RS dập nổi trên tựa đầu, hai chế độ lái RS1/RS2 tùy chỉnh riêng trên vô-lăng.', 4 FROM cars WHERE model_slug = 'rs6-avant';
