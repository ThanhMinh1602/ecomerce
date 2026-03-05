import 'package:ecomerce/core/components/button/custom_menu_button.dart';
import 'package:flutter/material.dart';



class ProfileMenuItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    return CustomMenuButton(
      iconPath: iconPath,
      title: title,
      onTap: onTap,
      
    );
  }
}