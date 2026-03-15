import 'package:flutter/material.dart';
import '../../../../../core/constants/app_style.dart';

class ProfileHeaderInfo extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;

  const ProfileHeaderInfo({
    super.key,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3.0),
            image: DecorationImage(
              image: NetworkImage(avatarUrl),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Text(
          name,
          style: AppStyle.contentBold.copyWith(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 4),

        Text(
          email,
          style: AppStyle.smallContentRegular.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
