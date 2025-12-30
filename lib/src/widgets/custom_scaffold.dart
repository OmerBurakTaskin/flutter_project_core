import 'package:flutter/material.dart';
import 'package:flutter_project_core/src/extensions/context_extensions.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.isScrollable = false,
    this.resizeToAvoidBottomInset = false,
    this.backgroundColor,
    this.isCentered,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  final Widget body;

  final double horizontalPadding;
  final double verticalPadding;
  final bool isScrollable;
  final bool resizeToAvoidBottomInset;
  final bool? isCentered;
  final Color? backgroundColor;

  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? context.colorScheme.surface,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: _buildContentContainer(context),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
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
