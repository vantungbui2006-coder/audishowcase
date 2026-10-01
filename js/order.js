/**
 * js/order.js — Chuyển đổi hiển thị panel QR / Tiền mặt theo lựa chọn
 * của khách hàng trong order.php.
 */
document.addEventListener('DOMContentLoaded', function () {
    var radios = document.querySelectorAll('input[name="payment_method"]');
    var methodCards = document.querySelectorAll('.payment-method');

    radios.forEach(function (radio) {
        radio.addEventListener('change', function () {
            // Ẩn hết các panel, xóa class "selected" khỏi mọi thẻ chọn phương thức
            document.querySelectorAll('.payment-panel').forEach(function (panel) {
                panel.classList.remove('active');
            });
            methodCards.forEach(function (card) {
                card.classList.remove('selected');
            });

            // Hiện đúng panel tương ứng + đánh dấu thẻ đang chọn
            var panelId = this.closest('.payment-method').dataset.panel;
            document.getElementById(panelId).classList.add('active');
            this.closest('.payment-method').classList.add('selected');
        });
    });
});
