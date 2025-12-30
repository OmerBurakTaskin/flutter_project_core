import 'package:flutter/material.dart';
import 'package:flutter_project_core/src/extensions/context_extensions.dart';
import 'package:flutter_project_core/src/theme/app_text_styles.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    this.name,
    this.profilePictureUrl,
    this.radius = 48,
  });
  final String? name;
  final String? profilePictureUrl;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colorScheme.primary.withAlpha(200),
      foregroundImage: NetworkImage(profilePictureUrl ?? ""),
      child: name != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: name!
                  .split(" ")
                  .map(
                    (name) => Text(
                      name[0].toUpperCase(),
                      style: TextStyles.bold28.copyWith(
                        fontSize: radius / 1.5,
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }
}
