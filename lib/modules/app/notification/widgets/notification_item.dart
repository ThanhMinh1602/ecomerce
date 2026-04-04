import 'package:ecomerce/data/enums/notification_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_asset.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';


class NotificationItem extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String message;
  final String? highlightText;
  final String? productImageUrl;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.highlightText,
    this.productImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: AppColor.black100.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: Center(child: _buildLeadingIcon()),
            ),
            const SizedBox(width: 16.0),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppStyle.smallContentBold.copyWith(
                      color: AppColor.black500,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  _buildMessageText(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    if (type == NotificationType.order && productImageUrl != null && productImageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          productImageUrl!,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
      );
    }
    return Image.asset(type.iconPath, width: 60);
  }
  Widget _buildMessageText() {
    final defaultStyle = AppStyle.smallContentRegular.copyWith(
      color: AppColor.k949494,
      fontSize: 13.0,
      height: 1.4,
    );

    if (highlightText == null || !message.contains(highlightText!)) {
      return Text(message, style: defaultStyle);
    }

    final parts = message.split(highlightText!);

    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: highlightText,
            style: defaultStyle.copyWith(
              color: AppColor.orange500,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}