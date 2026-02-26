enum UserRole {
  customer('customer'),
  employee('employee'), // Thêm role cho nhân viên
  admin('admin');

  // Khai báo biến lưu trữ giá trị chuỗi (String) cho từng role
  final String value;

  // Enum Constructor
  const UserRole(this.value);

  // --- Hàm hỗ trợ cực kỳ hữu ích khi làm việc với Firebase ---

  // Chuyển từ String (trên Firestore) về Enum để dùng trong App
  static UserRole fromString(String roleString) {
    return UserRole.values.firstWhere(
      (role) => role.value == roleString,
      orElse: () =>
          UserRole.customer, // Trả về mặc định là customer nếu không khớp
    );
  }
}
