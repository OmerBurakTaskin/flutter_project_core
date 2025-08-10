import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.isScrollable = false,
    this.resizeToAvoidBottomInset = false,
    this.backgroundColor,
    this.provider,
    this.isCentered,
    this.appBar,
    this.bottomNavigationBar,
  });

  final Widget body;
  final StateNotifierProvider? provider;
  final double horizontalPadding;
  final double verticalPadding;
  final bool isScrollable;
  final bool resizeToAvoidBottomInset;
  final bool? isCentered;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: _buildContentContainer(context),
    );
  }

  Widget _buildContentContainer(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: isScrollable ? 0 : verticalPadding,
        ),
        child: isScrollable
            ? (isCentered ?? false)
                ? Center(child: SingleChildScrollView(child: body))
                : SingleChildScrollView(child: body)
            : (isCentered ?? false)
                ? Center(child: body)
                : body,
      ),
    );
  }
}
