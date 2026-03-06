import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/components/custom_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthLayoutWrapper extends StatelessWidget {
  final RxBool isLoading;
  final GlobalKey<FormState> formKey;
  final PreferredSizeWidget? appBar;
  final double crowdedThreshold;
  final Widget Function(BuildContext context, bool isCrowded) builder;
  final Widget? bottomNavigationBar;

  const AuthLayoutWrapper({
    super.key,
    required this.isLoading,
    required this.formKey,
    required this.builder,
    this.appBar,
    this.crowdedThreshold = 500.0,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        body: SafeArea(
          child: CustomLoadingOverlay(
            isLoading: isLoading,
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isCrowded = constraints.maxHeight < crowdedThreshold;
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        child: IntrinsicHeight(
                          child: builder(context, isCrowded),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
