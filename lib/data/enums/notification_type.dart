import '../../../../../core/constants/app_asset.dart';

enum NotificationType {
  
  order('order', 'Your order', AppAsset.yourOrder),
  promotion('promotion', 'Promotion', AppAsset.specialDiscount),
  update('update', 'Update', AppAsset.update);
  final String code; 
  final String defaultTitle; 
  final String iconPath;
  const NotificationType(this.code, this.defaultTitle, this.iconPath);
  static NotificationType fromString(String typeCode) {
    return NotificationType.values.firstWhere(
          (e) => e.code == typeCode,
      orElse: () => NotificationType.update, 
    );
  }
}