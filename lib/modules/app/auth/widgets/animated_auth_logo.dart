import 'package:ecomerce/core/components/animation/custom_animated_visibility.dart';
import 'package:ecomerce/modules/app/auth/widgets/auth_logo.dart';
import 'package:flutter/material.dart';

class AnimatedAuthLogo extends StatelessWidget {
  final bool isCrowded;

  const AnimatedAuthLogo({super.key, required this.isCrowded});

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedVisibility(
      visible: !isCrowded,
      child: SizedBox(
        width: double.infinity,
        key: const ValueKey('logo'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            AuthLogo(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}