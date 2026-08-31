/// Nhãn tiếng Việt cho các giá trị enum (dạng chuỗi) mà backend trả về —
/// gom về 1 chỗ để không phải lặp lại/khai báo rời rạc ở từng màn hình.
class AppLabels {
  AppLabels._();

  static const gender = {
    'MALE': 'Nam',
    'FEMALE': 'Nữ',
    'OTHER': 'Khác',
  };

  static const travelStyle = {
    'SOLO': 'Một mình',
    'COUPLE': 'Cặp đôi',
    'FAMILY': 'Gia đình',
    'GROUP': 'Nhóm bạn',
  };

  static const budgetLevel = {
    'LOW': 'Tiết kiệm',
    'MEDIUM': 'Vừa phải',
    'HIGH': 'Thoải mái',
  };

  static const placeSortBy = {
    'POPULAR': 'Phổ biến',
    'RATING': 'Đánh giá cao',
    'NEWEST': 'Mới nhất',
    'PRICE_ASC': 'Giá tăng dần',
    'PRICE_DESC': 'Giá giảm dần',
  };
}
