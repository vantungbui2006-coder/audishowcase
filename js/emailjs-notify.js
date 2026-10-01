/**
 * js/emailjs-notify.js — Gửi email thông báo qua EmailJS từ trình duyệt khách hàng.
 *
 * Chạy ở TRÌNH DUYỆT nên không bị giới hạn chặn SMTP của hosting miễn phí;
 * hoạt động được ở cả localhost lẫn hosting thật.
 *
 * CÁCH HOẠT ĐỘNG (đã sửa lỗi "yêu cầu bị hủy giữa chừng"):
 *  1. Khi khách bấm gửi form, ta CHẶN việc chuyển trang lại (preventDefault).
 *  2. Gửi email qua EmailJS và ĐỢI kết quả (tối đa 4 giây).
 *  3. Dù email thành công, thất bại hay quá 4 giây, ta LUÔN cho form submit
 *     tiếp tới PHP để lưu dữ liệu vào database như bình thường.
 *
 * Vì sao phải đợi? Nếu để form chuyển trang ngay, trình duyệt sẽ hủy mọi
 * yêu cầu đang gửi dở, email chưa kịp tới EmailJS. Đợi xong rồi mới chuyển
 * trang thì yêu cầu chắc chắn được gửi đi.
 *
 * Email chỉ là tính năng phụ: lỗi email KHÔNG bao giờ được làm mất dữ liệu khách.
 */

document.addEventListener('DOMContentLoaded', function () {
    if (typeof emailjs === 'undefined') return; // SDK không nạp được -> bỏ qua, form chạy bình thường

    emailjs.init({ publicKey: EMAILJS_PUBLIC_KEY });

    var MAX_WAIT_MS = 4000; // đợi EmailJS tối đa 4 giây rồi vẫn cho form đi tiếp

    /**
     * attachNotify — gắn hành vi "gửi email rồi mới submit" cho 1 form.
     * buildParams(data, form) trả về object tham số gửi lên EmailJS.
     */
    function attachNotify(form, buildParams) {
        form.addEventListener('submit', function (event) {
            event.preventDefault(); // giữ khách ở lại trang cho tới khi email gửi xong

            var submitBtn = form.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;               // tránh bấm 2 lần
                submitBtn.dataset.oldText = submitBtn.textContent;
                submitBtn.textContent = 'Đang gửi...';
            }

            var finished = false;
            function continueSubmit() {
                if (finished) return;
                finished = true;
                form.submit(); // submit thật tới PHP (form.submit() không kích hoạt lại sự kiện submit)
            }

            // Phòng trường hợp mạng chậm/treo: quá MAX_WAIT_MS vẫn cho form đi tiếp
            setTimeout(continueSubmit, MAX_WAIT_MS);

            try {
                var params = buildParams(new FormData(form), form);
                emailjs.send(EMAILJS_SERVICE_ID, EMAILJS_TEMPLATE_ID, params).then(
                    function () { continueSubmit(); },
                    function (err) {
                        console.warn('Gửi email EmailJS thất bại (dữ liệu vẫn được lưu):', err);
                        continueSubmit();
                    }
                );
            } catch (e) {
                console.warn('Lỗi khi chuẩn bị email (dữ liệu vẫn được lưu):', e);
                continueSubmit();
            }
        });
    }

    // ---------- Form liên hệ (contact-form.php) ----------
    var contactForm = document.querySelector('.contact-form');
    if (contactForm) {
        attachNotify(contactForm, function (data, form) {
            var carSelect = form.querySelector('select[name="car_id"]');
            var carName = (data.get('car_id') && carSelect)
                ? carSelect.options[carSelect.selectedIndex].textContent.trim()
                : 'Chưa xác định';

            var message = [
                'KHÁCH HÀNG MỚI ĐỂ LẠI THÔNG TIN LIÊN HỆ',
                '',
                'Họ tên: ' + (data.get('full_name') || '—'),
                'Số điện thoại: ' + (data.get('phone') || '—'),
                'Email: ' + (data.get('email') || '—'),
                'Địa chỉ: ' + (data.get('address') || '—'),
                'Người giới thiệu: ' + (data.get('referral_source') || '—'),
                'Xe quan tâm: ' + carName,
                'Lời nhắn: ' + (data.get('message') || '—'),
            ].join('\n');

            return {
                subject: '🔔 Khách hàng mới liên hệ: ' + (data.get('full_name') || ''),
                message: message,
                // `name` và `email` dùng cho tính năng Trả lời tự động (Auto-Reply):
                // EmailJS lấy `email` làm địa chỉ nhận thư xác nhận gửi cho KHÁCH HÀNG.
                // Khách không nhập email (ô không bắt buộc) thì auto-reply tự bỏ qua.
                name: data.get('full_name') || '',
                email: data.get('email') || '',
            };
        });
    }

    // ---------- Form đặt mua xe (order.php) ----------
    var orderForm = document.querySelector('form[action="submit-order.php"]');
    if (orderForm) {
        attachNotify(orderForm, function (data) {
            var paymentLabel = data.get('payment_method') === 'qr' ? 'Quét mã QR (demo)' : 'Tiền mặt tại đại lý';
            var carNameEl = document.querySelector('.order-summary h2');
            var carName = carNameEl ? carNameEl.textContent.trim() : 'Xe Audi';

            var message = [
                'ĐƠN ĐẶT MUA XE MỚI (DEMO)',
                '',
                'Xe: ' + carName,
                'Khách hàng: ' + (data.get('customer_name') || '—'),
                'Số điện thoại: ' + (data.get('phone') || '—'),
                'Phương thức thanh toán: ' + paymentLabel,
                'Đã nộp CCCD: ' + (data.get('id_card_number') ? 'Có' : 'Không'),
            ].join('\n');

            return {
                subject: '🚗 Đơn đặt mua mới: ' + carName,
                message: message,
                name: data.get('customer_name') || '',
                email: '', // form đặt mua chưa thu thập email khách -> không có auto-reply
            };
        });
    }
});
